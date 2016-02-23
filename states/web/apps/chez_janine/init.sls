{% from 'letsencrypt/init.sls' import certificate %}

web.apps.chez_janine.mariadb:
  pkg.installed:
    - pkgs:
      - php-gd
  mysql_database.present:
    - name: chez_janine
    - require:
      - service: mariadb
  mysql_user.present:
    - name: chez_janine
    - password: "{{ pillar['database']['accounts']['chez_janine']['password'] }}"
    - host: localhost
    - require:
      - service: mariadb
  mysql_grants.present:
    - database: chez_janine.*
    - grant: all privileges
    - user: chez_janine
    - host: localhost
    - require:
      - mysql_database: chez_janine
      - mysql_user: chez_janine

{{ certificate('chez_janine', 'chez-janine.de', 'www.chez-janine.de') }}

web.apps.chez_janine.httpd:
  file.managed:
    - name: /etc/httpd/conf/vhosts/chez_janine.conf
    - source: salt://web/apps/chez_janine/httpd.conf
    - makedirs: True
    - require:
      - cmd: letsencrypt.domains.chez_janine.crt

web.apps.chez_janine.site:
  archive.extracted:
    - name: /srv/http/chez_janine
    - source: http://wordpress.org/latest.tar.gz
    - source_hash: sha512=7963f42a20b0c4fb8bbab4e2ee464ed4d1fc69c194eaefb7c4a0a7a77c4f44e846e8a1322a5fee57788b8af5a5be2a946fb8615e020faa098a985aa48c9da35a
    - archive_format: tar
    - tar_options: --gzip --strip-components=1
    - user: http
    - group: http

web.apps.chez_janine.conf:
  file.managed:
    - name: /srv/http/chez_janine/wp-config.php
    - source: salt://web/apps/chez_janine/wp-config.php.tmpl
    - makedirs: True
    - template: jinja
    - user: http
    - group: http

web.apps.chez_janine.data:
  file.symlink:
    - name: /srv/http/chez_janine/wp-content
    - target: /srv/data/web/chez_janine
    - force: True
    - makedirs: True
    - user: http
    - group: http
