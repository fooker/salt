{% from 'letsencrypt/init.sls' import certificate %}


nginx:
  pkg.installed:
    - name: nginx
  service.running:
    - enable: True
    - name: nginx
    - require:
      - pkg: nginx
    - watch:
      - file: /etc/nginx/*
      - file: /etc/nginx/vhosts/*
  file.directory:
    - name: /etc/nginx/vhosts
    - makedirs: True
    - clean: True

nginx.conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/nginx.conf

nginx.iptables:
  file.managed:
    - name: /etc/ferm.d/nginx.conf
    - source: salt://nginx/files/ferm.conf
    - require_in:
      - file: ferm


{% macro vhost(module, source, domains) %}
{{ certificate(module, domains) }}

nginx.conf.vhosts.{{ module }}:
  file.managed:
    - name: /etc/nginx/vhosts/{{ module }}.conf
    - source: {{ source }}
    - makedirs: True
    - template: jinja
    - defaults:
        name: {{ module }}
        domains: {{ domains | yaml() }}
    - context:
        {{ kwargs | yaml() }}
    - require_in:
      - file: nginx
    - require:
      - cmd: letsencrypt.domains.{{ module }}.crt
{% endmacro %}
