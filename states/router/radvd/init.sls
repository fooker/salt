radvd:
  pkg.installed:
    - name: radvd
  service.running:
    - enable: True
    - name: radvd
    - require:
      - pkg: radvd
    - watch:
      - file: /etc/radvd.conf

radvd.config:
  file.managed:
    - name: /etc/radvd.conf
    - source: salt://router/radvd/files/radvd.conf.j2
    - makedirs: True
    - template: jinja
