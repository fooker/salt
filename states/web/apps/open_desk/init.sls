{% from 'letsencrypt/init.sls' import certificate %}

web.apps.open_desk.mariadb:
  pkg.installed:
    - pkgs:
      - php-gd
  mysql_database.present:
    - name: open_desk
    - require:
      - service: mariadb
  mysql_user.present:
    - name: open_desk
    - password: "{{ pillar['database']['accounts']['open_desk']['password'] }}"
    - host: localhost
    - require:
      - service: mariadb
  mysql_grants.present:
    - database: open_desk.*
    - grant: all privileges
    - user: open_desk
    - host: localhost
    - require:
      - mysql_database: open_desk
      - mysql_user: open_desk

{{ certificate('open_desk', 'open-desk.org', 'www.open-desk.org') }}

web.apps.open_desk.httpd:
  file.managed:
    - name: /etc/httpd/conf/vhosts/open_desk.conf
    - source: salt://web/apps/open_desk/httpd.conf
    - makedirs: True
    - require:
      - cmd: letsencrypt.domains.open_desk.crt

web.apps.open_desk.site:
  archive.extracted:
    - name: /srv/http/open_desk
    - source: http://wordpress.org/latest.tar.gz
    - source_hash: sha512=dfced463ece13f266c15e1b45d8e7882e58ce9cd3b7146c81a4671bc51c58998ae318bd6e45b1f7bc657e2d49d7d39f971d814998e074375129c8dff7cfcac63
    - archive_format: tar
    - tar_options: --gzip --strip-components=1
    - user: http
    - group: http

web.apps.open_desk.conf:
  file.managed:
    - name: /srv/http/open_desk/wp-config.php
    - source: salt://web/apps/open_desk/wp-config.php.tmpl
    - makedirs: True
    - template: jinja
    - user: http
    - group: http

web.apps.open_desk.data:
  file.symlink:
    - name: /srv/http/open_desk/wp-content
    - target: /srv/data/web/open_desk
    - force: True
    - makedirs: True
    - user: http
    - group: http

