include:
  - letsencrypt


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
    - source: salt://web/apache/httpd.conf
    - makedirs: True

{% for conf in ('ssl', 'letsencrypt', 'autoindex', 'info', 'php') %}
web.apache.conf.{{ conf }}:
  file.managed:
    - name: /etc/httpd/conf/httpd.{{ conf }}.conf
    - source: salt://web/apache/httpd.{{ conf }}.conf
{% endfor %}

web.apache.default:
  file.managed:
    - name: /srv/http/default/index.html
    - source: salt://web/apache/default.index.html
    - makedirs: True

web.apache.default.conf:
  file.managed:
    - name: /etc/httpd/conf/httpd.default.conf
    - source: salt://web/apache/httpd.default.conf.tmpl
    - template: jinja

web.apache.iptables:
  file.managed:
    - name: /etc/ferm.d/apache.conf
    - source: salt://web/apache/ferm.conf
    - makedirs: True

