include:
  - common.cron

rsnapshot:
  pkg.installed:
    - pkgs:
      - rsnapshot

rsnapshot.conf:
  file.managed:
    - name: /etc/rsnapshot.conf
    - source: salt://rsnapshot/rsnapshot.conf.tmpl
    - makedirs: True
    - template: jinja

rsnapshot.cron:
  file.managed:
    - name: /etc/cron.d/rsnapshot
    - source: salt://rsnapshot/rsnapshot.cron.tmpl
    - makedirs: True
    - template: jinja

rsnapshot.ssh:
  file.managed:
    - name: /etc/rsnapshot.id
    - contents_pillar: backup:ssh:key:secret
    - makedirs: True
    - mode: 600

