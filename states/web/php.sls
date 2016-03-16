include:
  - cluster


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
    - source: salt://web/php.extensions.ini
    - makedirs: True

web.php.mysql:
  file.managed:
    - name: /etc/php/conf.d/mysql.ini
    - source: salt://web/php.mysql.ini
    - makedirs: True

web.php.apcu:
  pkg.installed:
    - pkgs:
      - php-apcu
      - php-apcu-bc
  file.managed:
    - name: /etc/php/conf.d/apcu.ini
    - source: salt://web/php.apcu.ini
    - makedirs: True

web.php.memcached:
  pkg.installed:
    - pkgs:
      - php-memcached
  file.managed:
    - name: /etc/php/conf.d/memcached.ini
    - source: salt://web/php.memcached.ini.tmpl
    - template: jinja
    - makedirs: True

web.php.data:
  file.managed:
    - name: /etc/php/conf.d/data.ini
    - source: salt://web/php.data.ini
    - makedirs: True

