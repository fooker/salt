include:
  - router.dnsmasq

dhcp.dnsmasq:
  file.managed:
    - name: /etc/dnsmasq.conf.d/dhcp.conf
    - source: salt://router/dhcp/files/dnsmasq.conf.j2
    - makedirs: True
    - template: jinja

dhcp.ferm:
  file.managed:
    - name: /etc/ferm.d/dhcp.conf
    - source: salt://router/dhcp/files/ferm.conf
    - require_in:
      - file: ferm
