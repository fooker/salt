{% import 'rsnapshot/target/init.sls' as backup with context %}

weechat:
  pkg.installed:
    - name: weechat

weechat.user:
  user.present:
    - name: weechat
    - home: /var/lib/weechat
    - createhome: True
    - empty_password: True
  ssh_auth.present:
    - name: {{ pillar['ssh']['authorized_keys']['fooker'] }}
    - user: weechat
    - comment: fooker
    - options:
      - no-port-forwarding
      - no-X11-forwarding

weechat.service:
  file.managed:
    - name: /etc/systemd/system/weechat.service
    - source: salt://weechat/service
    - makedirs: True
  service.running:
    - name: weechat
    - enable: True
    - require:
      - pkg: weechat
      - file: /etc/systemd/system/weechat.service

{{ backup.target('weechat', '/var/lib/weechat') }}

