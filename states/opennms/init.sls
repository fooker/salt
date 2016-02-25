{% from 'letsencrypt/init.sls' import certificate %}


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

{{ certificate('opennms', 'opennms.open-desk.net') }}

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
    - makedirs: True

