{% import 'rsnapshot/target/init.sls' as rsnapshot %}


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

{{ rsnapshot.target('redis', '/var/lib/redis/dump.rdb') }}
