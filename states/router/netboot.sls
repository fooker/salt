include:
  - router.dnsmasq

tftp.dnsmasq:
  file.managed:
    - name: /etc/dnsmasq.conf.d/tftp.conf
    - source: salt://router/dnsmasq.tftp.conf
    - makedirs: True

tftp.ferm:
  file.managed:
    - name: /etc/ferm.d/tftp.conf
    - source: salt://router/ferm.tftp.conf
    - require_in:
      - file: ferm
