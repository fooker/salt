include:
  - hive


web.php:
  pkg.installed:
    - pkgs:
      - php
{%- for package in pillar.web.php.packages %}
      - php-{{ package }}
{%- endfor %}

web.php.extensions:
  pkg.installed:
    - pkgs:
      - php-gd
  file.managed:
    - name: /etc/php/conf.d/extensions.ini
    - source: salt://web/php/files/php.extensions.ini
    - makedirs: True

web.php.extensions.mysql:
  file.managed:
    - name: /etc/php/conf.d/mysql.ini
    - source: salt://web/php/files/php.mysql.ini
    - makedirs: True

web.php.extensions.apcu:
  pkg.installed:
    - pkgs:
      - php-apcu
      - php-apcu-bc
  file.managed:
    - name: /etc/php/conf.d/apcu.ini
    - source: salt://web/php/files/php.apcu.ini
    - makedirs: True

web.php.memcached:
  pkg.installed:
    - pkgs:
      - memcached
  file.managed:
    - name: /usr/local/systemd/system/memcached.service.d/service.conf
    - source: salt://web/php/files/memcached.service.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: systemd.system
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
    - source: salt://web/php/files/php.memcached.ini.j2
    - template: jinja
    - makedirs: True

