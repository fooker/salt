{% import 'nfs/client/init.sls' as nfs %}

include:
  - letsencrypt
  - nfs/client
  - web/php


web.apache:
  pkg.installed:
    - pkgs:
      - apache
      - nghttp2
      - php-apache
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
    - source: salt://web/apache/files/httpd.conf
    - makedirs: True

{% for conf in ('ssl', 'letsencrypt', 'autoindex', 'info', 'php') %}
web.apache.conf.{{ conf }}:
  file.managed:
    - name: /etc/httpd/conf/httpd.{{ conf }}.conf
    - source: salt://web/apache/files/httpd.{{ conf }}.conf
{% endfor %}

{{ nfs.mount('apache', 'http', '/srv/http') }}

web.apache.default:
  file.managed:
    - name: /srv/http/default/index.html
    - source: salt://web/apache/files/default.index.html
    - makedirs: True
    - require:
      - mount: nfs.client.mount.apache

web.apache.default.conf:
  file.managed:
    - name: /etc/httpd/conf/httpd.default.conf
    - source: salt://web/apache/files/httpd.default.conf.j2
    - template: jinja

web.apache.iptables:
  file.managed:
    - name: /etc/ferm.d/apache.conf
    - source: salt://web/apache/files/ferm.conf
    - require_in:
      - file: ferm

