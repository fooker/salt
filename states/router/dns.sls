include:
  - router.dnsmasq

dns.dnsmasq:
  file:
    - managed
    - name: /etc/dnsmasq.conf.d/dns.conf
    - source: salt://router/dnsmasq.dns.conf.tmpl
    - template: jinja
    - makedirs: True

dns.ferm:
  file:
    - managed
    - name: /etc/ferm.d/dns.conf
    - source: salt://router/ferm.dns.conf
    - makedirs: True

