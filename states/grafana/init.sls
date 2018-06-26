{% import 'rsnapshot/target/init.sls' as rsnapshot %}
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

{{ nginx.vhost('grafana', 'salt://nginx/files/vhost/proxy.conf.j2', ['grafana.open-desk.net'], target='127.0.0.1:6000') }}


{{ rsnapshot.target('grafana', '/var/lib/grafana') }}

