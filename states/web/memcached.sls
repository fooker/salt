include:
  - cluster


web.memcached:
  pkg.installed:
    - pkgs:
      - memcached
  file.managed:
    - name: /etc/systemd/system/memcached.service.d/service.conf
    - source: salt://web/memcached.service.conf.tmpl
    - makedirs: True
    - template: jinja
  service.running:
    - enable: True
    - name: memcached
    - require:
      - pkg: web.memcached
      - file: web.memcached

