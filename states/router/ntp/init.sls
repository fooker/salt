ntp:
  pkg.installed:
    - name: ntp
  service.running:
    - enable: True
    - name: ntpd
    - require:
      - pkg: ntp
    - watch:
      - file: /etc/ntp.conf

ntp.conf:
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://router/ntp/files/ntp.conf
    - makedirs: True


ntp.iptables:
  file.managed:
    - name: /etc/ferm.d/ntp.conf
    - source: salt://router/ntp/files/ferm.conf
    - require_in:
      - file: ferm
