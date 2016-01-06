ntp:
  pkg.installed:
    - name: ntp
  service.running:
    - name: ntpd
    - enable: True
    - require:
      - pkg: ntp
    - watch:
      - file: /etc/ntp.conf

ntp.conf:
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://common/ntp.conf.tmpl
    - makedirs: True
    - template: jinja


