{% import 'letsencrypt/init.sls' as letsencrypt %}
{% import 'glusterfs/init.sls' as glusterfs %}
{% import 'mariadb/init.sls' as mariadb %}

{% for app in pillar['web']['apps'] %}

{{ mariadb.database(app) }}
{{ glusterfs.volume(app, '/srv/http/' + app) }}
{{ letsencrypt.certificate(app, pillar['web']['apps'][app]['domains']) }}

web.apps.{{ app }}.httpd.conf:
  file.managed:
    - name: /etc/httpd/conf/vhosts/{{ app }}.conf
    - source: salt://web/apps/{{ app }}.httpd.conf
    - makedirs: True
    - require:
      - cmd: letsencrypt.domains.{{ app }}.crt

{% endfor %}

