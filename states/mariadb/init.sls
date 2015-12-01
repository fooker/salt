mariadb.tools:
  pkg:
    - installed
    - pkgs:
      - mysql-python  # Required to make mysql_* states work
      - lsof

mariadb:
  pkg:
    - installed
    - sources:
      - mariadb: 'http://arch.jensgutermuth.de/testing/os/x86_64/mariadb-10.1.9-2-x86_64.pkg.tar.xz'
      - galera: 'salt://mariadb/galera-25.3.13-1-x86_64.pkg.tar.xz'
  service:
    - running
    - enable: True
    - name: mysqld
    - require:
      - pkg: mariadb
      - cmd: mariadb.init.pre
    - watch:
      - file: /etc/mysql/*
      - pkg: mariadb

mariadb.config:
  file:
    - managed
    - name: /etc/mysql/my.cnf
    - source: salt://mariadb/my.cnf.tmpl
    - makedirs: True
    - template: jinja

mariadb.init.pre:
  cmd:
    - run
    - name: mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    - creates: /var/lib/mysql
    - require:
      - pkg: mariadb
      - file: /etc/mysql/*

mariadb.init.post:
  mysql_query:
    - run
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
  mysql_user:
    - present
    - name: root
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True

mariadb.auth.monitoring:
  mysql_user:
    - present
    - name: monitoring
    - password: "{{ pillar['database']['monitoring']['password'] }}"
    - host: {{ pillar['addresses'][pillar['database']['monitoring']['host']]['int']['mngt']['ip4'] }}

mariadb.iptables:
  file:
    - managed
    - name: /etc/ferm.d/mariadb.conf
    - source: salt://mariadb/ferm.conf
    - makedirs: True
