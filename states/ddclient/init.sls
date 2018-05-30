ddclient:
  pkg.installed:
    - name: ddclient
  service.running:
    - enable: True
    - name: ddclient
    - require:
      - pkg: ddclient
    - watch:
      - file: /etc/ddclient/ddclient.conf


ddclient.conf:
  file.managed:
    - name: /etc/ddclient/ddclient.conf
    - source: salt://ddclient/files/ddclient.conf.j2
    - template: jinja
    - makedirs: True

