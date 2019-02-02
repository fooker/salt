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

unbound.roothints:
  file.managed:
    - name: /etc/unbound/named.cache
    - source: https://www.internic.net/domain/named.cache
    - source_hash: https://www.internic.net/domain/named.cache.md5
    - watch_in:
      - service: unbound

unbound.roothints.service:
  file.managed:
    - name: /usr/local/lib/systemd/system/unbound-roothints.service
    - source: salt://unbound/files/roothints.service
    - require_in:
      - file: systemd.system

unbound.roothints.timer:
  file.managed:
    - name: /usr/local/lib/systemd/system/unbound-roothints.timer
    - source: salt://unbound/files/roothints.timer
    - require_in:
      - file: systemd.system
  
  service.running:
    - name: unbound-roothints.timer
    - enable: True
    - watch:
      - file: unbound.roothints.service
      - file: unbound.roothints.timer

unbound.conf:
  file.managed:
    - name: /etc/unbound/unbound.conf
    - source: salt://unbound/files/unbound.conf.j2
    - makedirs: True
    - template: jinja
    - watch_in:
      - service: unbound
