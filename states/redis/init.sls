{% import 'backup/client/init.sls' as backup %}


redis:
  pkg.installed:
    - name: redis
  
  service.running:
    - name: redis
    - enable: True
    - require:
      - pkg: redis

redis.config:
  file.managed:
    - name: /etc/redis.conf
    - source: salt://redis/files/redis.conf.j2
    - makedisr: True
    - template: jinja
    - watch_in:
      - service: redis

{{ backup.dir('redis', '/var/lib/redis/dump.rdb') }}
