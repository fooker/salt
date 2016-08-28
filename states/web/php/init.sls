include:
  - hive


web.php:
  pkg.installed:
    - pkgs:
      - php
      - php-apache

web.php.extensions:
  pkg.installed:
    - pkgs:
      - php-gd
  file.managed:
    - name: /etc/php/conf.d/extensions.ini
    - source: salt://web/php/php.extensions.ini
    - makedirs: True

web.php.extensions.mysql:
  file.managed:
    - name: /etc/php/conf.d/mysql.ini
    - source: salt://web/php/php.mysql.ini
    - makedirs: True

web.php.extensions.apcu:
  pkg.installed:
    - pkgs:
      - php-apcu
      - php-apcu-bc
  file.managed:
    - name: /etc/php/conf.d/apcu.ini
    - source: salt://web/php/php.apcu.ini
    - makedirs: True

web.php.memcached:
  pkg.installed:
    - pkgs:
      - memcached
  file.managed:
    - name: /etc/systemd/system/memcached.service.d/service.conf
    - source: salt://web/php/memcached.service.conf
    - makedirs: True
  service.running:
    - enable: True
    - name: memcached
    - require:
      - pkg: web.php.memcached
      - file: web.php.memcached

web.php.extensions.memcached:
  pkg.installed:
    - pkgs:
      - php-memcached
  file.managed:
    - name: /etc/php/conf.d/memcachde.ini
    - source: salt://web/php/php.memcached.ini.tmpl
    - template: jinja
    - makedirs: True

