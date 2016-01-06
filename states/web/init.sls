

web.apache:
  pkg.installed:
    - pkgs:
      - apache
      - nghttp2
  service.running:
    - enable: True
    - name: httpd
    - require:
      - pkg: web.apache
    - watch:
      - file: /etc/httpd/*
      - file: /etc/php/*

web.apache.conf:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://web/apache.conf.tmpl
    - makedirs: True
    - template: jinja

web.data:
  glusterfs.created:
    - name: web
    - bricks: {% for node in pillar['cluster']['nodes'] %}
      - {{ node }}:/srv/glusterfs/web
      {%- endfor %}
    - start: True
    - require:
      - service: glusterfs
      - glusterfs: glusterfs.peers
  mount.mounted:
    - name: /srv/data/web
    - fstype: glusterfs
    - mkmnt: True
    - device: localhost:/web

web.iptables:
  file.managed:
    - name: /etc/ferm.d/web.conf
    - source: salt://web/ferm.conf
    - makedirs: True

web.php:
  pkg.installed:
    - pkgs:
      - php
      - php-apache

web.php.mysql:
  file.managed:
    - name: /etc/php/conf.d/mysql.ini
    - contents: |
        [PHP]
        extension=mysqli.so
        extension=pdo_mysql.so

web.php.gd:
  file.managed:
    - name: /etc/php/conf.d/gd.ini
    - contents: |
        [PHP]
        extension=gd.so
