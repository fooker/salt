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
    - source: salt://web/httpd.conf
    - makedirs: True

{% for conf in ('ssl', 'autoindex', 'info', 'php', 'default') %}
web.apache.conf.{{ conf }}:
  file.managed:
    - name: /etc/httpd/conf/httpd.{{ conf }}.conf
    - source: salt://web/httpd.{{ conf }}.conf
{% endfor %}

web.apache.default:
  file.managed:
    - name: /srv/http/default/index.html
    - source: salt://web/default.index.html
    - makedirs: True

web.apache.iptables:
  file.managed:
    - name: /etc/ferm.d/web.conf
    - source: salt://web/ferm.conf
    - makedirs: True

