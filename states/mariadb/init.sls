include:
  - hive

mariadb.tools:
  pkg.installed:
    - pkgs:
      - mysql-python  # Required to make mysql_* states work
      - lsof
      - xtrabackup

mariadb.server:
  pkg.installed:
    - name: mariadb

mariadb.galera:
  pkg.installed:
    - sources:
      - galera: 'salt://mariadb/galera-25.3.16-1-x86_64.pkg.tar.xz'

mariadb:
  service.running:
    - enable: True
    - name: mysqld
    - require:
      - pkg: mariadb
      - cmd: mariadb.init.pre
    - watch:
      - file: /etc/mysql/*
      - pkg: mariadb

mariadb.config:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://mariadb/my.cnf.tmpl
    - makedirs: True
    - template: jinja

mariadb.init.pre:
  cmd.run:
    - name: mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    - creates: /var/lib/mysql
    - require:
      - pkg: mariadb
      - file: /etc/mysql/*

mariadb.init.post:
  mysql_query.run:
    - database: mysql
    - query: |
        INSTALL SONAME 'wsrep_info';
        INSTALL SONAME 'auth_socket';
    - require:
      - service: mariadb

mariadb.auth.local:
  # This seems to be broken right now - workaround by execute on target:
  # mysql> INSTALL PLUGIN unix_socket SONAME 'auth_socket';
  # mysql> UPDATE mysql.user SET plugin='unix_socket' WHERE user='root' AND host='localhost';
  # mysql> FLUSH PRIVILEGES;
  mysql_user.present:
    - name: root
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True

mariadb.auth.monitoring:
  mysql_user.present:
    - name: monitoring
    - password: "{{ pillar['database']['accounts']['monitoring']['password'] }}"
    - host: {{ pillar['addresses'][pillar['database']['accounts']['monitoring']['host']]['int']['mngt']['ip4'] }}

{% if grains['id'] == "bunker" -%}
mariadb.rsnapshot:
  file.accumulated:
    - name: rsnapshot.backups
    - filename: /etc/rsnapshot.conf.incl
    - text: |
        backup_script	/usr/bin/innobackupex --no-timestamp --backup . &> /dev/null	{{ grains['id'] }}/mariadb
    - require_in:
      - file: rsnapshot.target.conf
{%- endif %}

{% macro database(module) %}
mariadb.database.{{ module }}:
  mysql_database.present:
    - name: {{ module }}
    - require:
      - service: mariadb
  mysql_user.present:
    - name: {{ module }}
    - password: "{{ pillar['database']['accounts'][module]['password'] }}"
    - host: localhost
    - require:
      - service: mariadb
  mysql_grants.present:
    - database: {{ module }}.*
    - grant: all privileges
    - user: {{ module }}
    - host: localhost
    - require:
      - mysql_database: {{ module }}
      - mysql_user: {{ module }}
{% endmacro %}

