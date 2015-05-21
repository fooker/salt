include:
  - router.dnsmasq

ffx.dnsmasq:
  file:
    - managed
    - name: /etc/dnsmasq.conf.d/ffx.conf
    - source: salt://router/dnsmasq.ffx.conf
    - makedirs: True

ffx.ferm:
  file:
    - managed
    - name: /etc/ferm.d/ffx.conf
    - source: salt://router/ferm.ffx.conf
    - makedirs: True

