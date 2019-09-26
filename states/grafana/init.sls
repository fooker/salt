{% import 'backup/client/init.sls' as backup %}
{% import 'nginx/init.sls' as nginx %}


include:
  - nginx


grafana:
  pkg.installed:
    - name: grafana

grafana.conf:
  file.managed:
    - name: /etc/grafana.ini
    - source: salt://grafana/files/grafana.ini
    - makedirs: True

grafana.service:
  service.running:
    - name: grafana
    - enable: True
    - watch:
      - file: /etc/grafana.ini
      - pkg: grafana

{{ nginx.vhost('grafana', source='salt://nginx/files/vhost/proxy.conf.j2', domains=['grafana.open-desk.net'], target='127.0.0.1:6000') }}
{{ nginx.vhost('grafana.to_ssl', source='salt://nginx/files/vhost/redirect-ssl.conf.j2', ssl=False, domains=['grafana.open-desk.net']) }}


{{ backup.dir('grafana', '/var/lib/grafana') }}

