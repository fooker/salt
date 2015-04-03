include:
  - router.dnsmasq

tftp:
  file:
    - directory
    - name: /srv/tftp
    - makedirs: True

tftp.dnsmasq:
  file:
    - managed
    - name: /etc/dnsmasq.conf.d/tftp.conf
    - source: salt://router/dnsmasq.tftp.conf
    - makedirs: True

tftp.ferm:
  file:
    - managed
    - name: /etc/ferm.d/tftp.conf
    - source: salt://router/ferm.tftp.conf
    - makedirs: True

