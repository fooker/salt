freifunk.dnsmasq:
  file.managed:
    - name: /etc/dnsmasq.conf.d/freifunk.conf
    - source: salt://router/dnsmasq.freifunk.conf
    - makedirs: True

freifunk.ferm:
  file.managed:
    - name: /etc/ferm.d/freifunk.conf
    - source: salt://router/ferm.freifunk.conf
    - makedirs: True
