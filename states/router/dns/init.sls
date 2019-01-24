include:
  - router.dnsmasq
  - unbound

dns.dnsmasq:
  file.managed:
    - name: /etc/dnsmasq.conf.d/dns.conf
    - source: salt://router/dns/files/dnsmasq.conf.j2
    - template: jinja
    - makedirs: True

dns.dnsmasq.hosts:
  file.managed:
    - name: /etc/dnsmasq.hosts
    - source: salt://router/dns/files/hosts.j2
    - makedirs: True
    - template: jinja

dns.ferm:
  file.managed:
    - name: /etc/ferm.d/dns.conf
    - source: salt://router/dns/files/ferm.conf
    - require_in:
      - file: ferm
