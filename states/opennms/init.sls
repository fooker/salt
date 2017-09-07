{% from 'letsencrypt/init.sls' import certificate %}
{% import 'rsnapshot/target/init.sls' as rsnapshot %}


opennms.nginx:
  pkg.installed:
    - name: nginx
  service.running:
    - enable: True
    - name: nginx
    - require:
      - pkg: nginx
    - watch:
      - file: /etc/nginx/*

{{ certificate('opennms', ['opennms.open-desk.net']) }}

opennms.nginx.conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://opennms/nginx.conf
    - require:
      - cmd: letsencrypt.domains.opennms.crt

opennms.iptables:
  file.managed:
    - name: /etc/ferm.d/opennms.conf
    - source: salt://opennms/ferm.conf
    - require_in:
      - file: ferm

opennms.grafana:
  pkg.installed:
    - name: grafana

opennms.grafana.conf:
  file.managed:
    - name: /etc/grafana.ini
    - source: salt://opennms/grafana.ini
    - makedirs: True

opennms.grafana.service:
  service.running:
    - name: grafana
    - enable: True
    - watch:
      - file: /etc/grafana.ini
      - pkg: grafana


{{ rsnapshot.target('opennms', '/opt/opennms/etc') }}
{{ rsnapshot.target('grafana', '/var/lib/grafana') }}

