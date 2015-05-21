include:
  - router.dnsmasq

dhcp.dnsmasq:
  file:
    - managed
    - name: /etc/dnsmasq.conf.d/dhcp.conf
    - source: salt://router/dnsmasq.dhcp.conf.tmpl
    - makedirs: True
    - template: jinja

dhcp.ferm:
  file:
    - managed
    - name: /etc/ferm.d/dhcp.conf
    - source: salt://router/ferm.dhcp.conf
    - makedirs: True

