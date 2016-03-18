unbound:
  pkg.installed:
    - pkgs:
      - unbound
      - expat
  service.running:
    - enable: True
    - name: unbound
    - require:
      - pkg: unbound
    - watch:
      - file: /etc/unbound/*

unbound.roots:
  file.managed:
    - name: /etc/unbound/named.cache
    - source: https://www.internic.net/domain/named.cache
    - source_hash: https://www.internic.net/domain/named.cache.md5

unbound.conf:
  file.managed:
    - name: /etc/unbound/unbound.conf
    - source: salt://router/unbound.conf.tmpl
    - makedirs: True
    - template: jinja

unbound.conf.hosts:
  file.managed:
    - name: /etc/unbound/unbound.hosts.conf
    - source: salt://router/unbound.hosts.conf.tmpl
    - makedirs: True
    - template: jinja

