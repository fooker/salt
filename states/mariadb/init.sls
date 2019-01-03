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
    - name: galera

mariadb:
  service.running:
    - enable: True
    - name: mariadb
    - require:
      - pkg: mariadb
      - cmd: mariadb.init
    - watch:
      - file: /etc/mysql/*
      - pkg: mariadb

mariadb.config:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://mariadb/files/my.cnf.tmpl
    - makedirs: True
    - template: jinja

mariadb.init:
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
    - require:
      - service: mariadb

mariadb.auth.monitoring:
  mysql_user.present:
    - name: monitoring
    - password: "{{ pillar['database']['accounts']['monitoring']['password'] }}"
    - host: {{ pillar['addresses'][pillar['database']['accounts']['monitoring']['host']]['int']['mngt']['ip4'] }}
    - require:
      - service: mariadb

{% if grains['id'] == "bunker" -%}
mariadb.rsnapshot:
  file.accumulated:
    - name: rsnapshot.backups
    - filename: /etc/rsnapshot.conf.incl
    - text: |
        backup_script	/usr/bin/ssh -o BatchMode=yes -o StrictHostKeyChecking=no -a -i /etc/rsnapshot.id root@bunker.dev.open-desk.net '/usr/bin/innobackupex --stream=tar ./ 2> /dev/null' | tar -x	mariadb
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

