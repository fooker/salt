{% from 'letsencrypt/init.sls' import certificate %}

web.apps.wolke.mariadb:
  pkg.installed:
    - pkgs:
      - php-gd
  mysql_database.present:
    - name: wolke
    - require:
      - service: mariadb
  mysql_user.present:
    - name: wolke
    - password: "{{ pillar['database']['accounts']['wolke']['password'] }}"
    - host: localhost
    - require:
      - service: mariadb
  mysql_grants.present:
    - database: wolke.*
    - grant: all privileges
    - user: wolke
    - host: localhost
    - require:
      - mysql_database: wolke
      - mysql_user: wolke

{{ certificate('wolke', 'wolke.kufuewg.de', 'cloud.kufuewg.de', 'cloud.open-desk.net') }}

web.apps.wolke.httpd:
  file.managed:
    - name: /etc/httpd/conf/vhosts/wolke.conf
    - source: salt://web/apps/wolke/httpd.conf
    - makedirs: True
    - require:
      - cmd: letsencrypt.domains.wolke.crt

web.apps.wolke.site:
  archive.extracted:
    - name: /srv/http/wolke
    - source: https://download.owncloud.org/community/owncloud-8.2.2.tar.bz2
    - source_hash: sha512=dfced463ece13f266c15e1b45d8e7882e58ce9cd3b7146c81a4671bc51c58998ae318bd6e45b1f7bc657e2d49d7d39f971d814998e074375129c8dff7cfcac63
    - archive_format: tar
    - tar_options: --bz2 --strip-components=1
    - user: http
    - group: http

web.apps.wolke.conf:
  file.managed:
    - name: /srv/http/wolke/wp-config.php
    - source: salt://web/apps/wolke/wp-config.php.tmpl
    - makedirs: True
    - template: jinja
    - user: http
    - group: http

web.apps.wolke.data:
  file.symlink:
    - name: /srv/http/wolke/wp-content
    - target: /srv/data/web/wolke
    - force: True
    - makedirs: True
    - user: http
    - group: http

