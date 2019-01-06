dhcp6c:
  pkg.installed:
    - name: wide-dhcpv6
  file.managed:
    - name: /etc/wide-dhcpv6/dhcp6c.conf
    - source: salt://dsl/dhcp6c/files/dhcp6c.conf.j2
    - makedirs: True
    - template: jinja

dhcp6c.service:
  service.running:
    - name: dhcp6c@ppp0
    - enable: True
    - watch:
      - pkg: dhcp6c
      - file: dhcp6c

dhcp6c.service.dependencies:
  file.managed:
    - name: /usr/local/systemd/system/dhcp6c@ppp0.service.d/dependencies.conf
    - source: salt://dsl/dhcp6c/files/dhcp6c.service.dependencies
    - makedirs: True
    - watch_in:
      - service: dhcp6c.service
    - require_in:
      - file: systemd.system

dhcp6c.ferm:
  file.managed:
    - name: /etc/ferm.d/dhcp6c.conf
    - source: salt://dsl/dhcp6c/files/ferm.conf
    - require_in:
      - file: ferm
