include:
  - common.cron

rsnapshot:
  pkg.installed:
    - pkgs:
      - rsnapshot

rsnapshot.conf:
  file.managed:
    - name: /etc/rsnapshot.conf
    - source: salt://rsnapshot/server/files/rsnapshot.conf.j2
    - makedirs: True
    - template: jinja

rsnapshot.cron:
  file.managed:
    - name: /etc/cron.d/rsnapshot
    - source: salt://rsnapshot/server/files/rsnapshot.cron.j2
    - makedirs: True
    - template: jinja

rsnapshot.ssh:
  file.managed:
    - name: /etc/rsnapshot.id
    - contents_pillar: backup:ssh:key:secret
    - makedirs: True
    - mode: 600

rsnpshot.snmpd.conf:
  file.managed:
    - name: /etc/snmp/snmpd.conf.d/rsnapshot.conf
    - source: salt://rsnapshot/server/files/snmpd.conf
    - makedirs: True
