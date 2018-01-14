ntp.legacy:
  pkg.purged:
    - name: ntp
  service.dead:
    - name: ntpd
    - enable: False
    - require:
      - pkg: ntp

ntp.legacy.conf:
  file.absent:
    - name: /etc/ntp.conf

timesyncd:
  file.managed:
    - name: /etc/systemd/timesyncd.conf
    - source: salt://common/timesyncd.conf.tmpl
    - makedirs: True
    - template: jinja

  service.running:
    - name: systemd-timesyncd.service
    - enable: True
    - watch:
      - file: timesyncd
