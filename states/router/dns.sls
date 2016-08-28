include:
  - common.cron
  - router.dnsmasq

dns.unbound:
  pkg.installed:
    - pkgs:
      - unbound
      - expat
  service.running:
    - enable: True
    - name: unbound
    - require:
      - pkg: dns.unbound
    - watch:
      - file: /etc/unbound/*

dns.unbound.roots:
  file.managed:
    - name: /etc/unbound/named.cache
    - source: https://www.internic.net/domain/named.cache
    - source_hash: https://www.internic.net/domain/named.cache.md5

dns.unbound.conf:
  file.managed:
    - name: /etc/unbound/unbound.conf
    - source: salt://router/unbound.conf.tmpl
    - makedirs: True
    - template: jinja

dns.dnsmasq:
  file.managed:
    - name: /etc/dnsmasq.conf.d/dns.conf
    - source: salt://router/dnsmasq.dns.conf.tmpl
    - template: jinja
    - makedirs: True

dns.ferm:
  file.managed:
    - name: /etc/ferm.d/dns.conf
    - source: salt://router/ferm.dns.conf
    - require_in:
      - file: ferm
