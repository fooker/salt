{% import 'letsencrypt/init.sls' as letsencrypt %}
{% import 'mariadb/init.sls' as mariadb %}


include:
  - web/apache
  - web/php
  - mariadb


{% for app in pillar.web.apps %}

{% if pillar.web.apps[app].database %}
{{ mariadb.database(app) }}
{% endif %}

{{ letsencrypt.certificate(app, pillar.web.apps[app].domains) }}

web.apps.{{ app }}.httpd.conf:
  file.managed:
    - name: /etc/httpd/conf/vhosts/{{ app }}.conf
    - source: salt://web/apps/files/{{ app }}.httpd.conf.j2
    - makedirs: True
    - template: jinja
    - context:
        app: {{ app }}
    - require:
      - cmd: letsencrypt.domains.{{ app }}.crt

{% endfor %}

