include:
  - common.cron
  - router.dnsmasq

dns.dnsmasq:
  file.managed:
    - name: /etc/dnsmasq.conf.d/dns.conf
    - source: salt://router/dnsmasq.dns.conf.tmpl
    - template: jinja
    - makedirs: True

dns.dnsmasq.servers:
  cmd.run:
    - name: curl -s 'https://api.opennicproject.org/geoip/?ns&ipv=4&res=3&pct=99' > /etc/dnsmasq.resolv
    - creates: /etc/dnsmasq.resolv
  cron.present:
    - name: curl -s 'https://api.opennicproject.org/geoip/?ns&ipv=4&res=3&pct=99' > /etc/dnsmasq.resolv
    - minute: random

dns.ferm:
  file.managed:
    - name: /etc/ferm.d/dns.conf
    - source: salt://router/ferm.dns.conf
    - makedirs: True

