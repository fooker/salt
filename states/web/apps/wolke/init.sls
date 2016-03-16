{% from 'letsencrypt/init.sls' import certificate %}

web.apps.wolke.mariadb:
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

web.apps.wolke.site:
  archive.extracted:
    - name: /srv/http/wolke
    - source: https://download.owncloud.org/community/owncloud-8.2.2.tar.bz2
    - source_hash: sha512=3830e8311931da3cbb596e927afe638dee6a5d9fd47d623faf4dabbde96fe39ced1bf7006c1b9e39ff52e72e2b849fe9d1012c3b1a86ca9f8c873d820b944b78
    - archive_format: tar
    - tar_options: --bzip2 --strip-components=1
    - user: root
    - group: http

{{ certificate('wolke', 'wolke.kufuewg.de', 'cloud.kufuewg.de', 'cloud.open-desk.net') }}

web.apps.wolke.httpd:
  file.managed:
    - name: /etc/httpd/conf/vhosts/wolke.conf
    - source: salt://web/apps/wolke/httpd.conf
    - makedirs: True
    - require:
      - cmd: letsencrypt.domains.wolke.crt
      - archive: web.apps.wolke.site

web.apps.wolke.conf:
  file.managed:
    - name: /srv/http/wolke/config/config.php
    - source: salt://web/apps/wolke/config.php.tmpl
    - makedirs: True
    - template: jinja
    - user: http
    - group: http

web.apps.wolke.cron:
  cron.present:
    - name: php -f /srv/http/wolke/cron.php
    - identifier: wolke
    - user: http
    - minute: '*/15'

