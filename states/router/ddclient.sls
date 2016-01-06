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
    - source: salt://router/ddclient.conf.tmpl
    - template: jinja
    - makedirs: True

