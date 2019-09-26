{% import 'backup/client/init.sls' as backup %}

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
    - name: {{ pillar.ssh.authorized_keys.fooker }}
    - user: weechat
    - comment: fooker
    - options:
      - no-port-forwarding
      - no-X11-forwarding

weechat.service:
  file.managed:
    - name: /usr/local/lib/systemd/system/weechat.service
    - source: salt://weechat/files/service
    - makedirs: True
    - require_in:
      - file: systemd.system
  service.running:
    - name: weechat
    - enable: True
    - require:
      - pkg: weechat
      - file: /usr/local/lib/systemd/system/weechat.service

weechat.iptables:
  file.managed:
    - name: /etc/ferm.d/weechat.conf
    - source: salt://weechat/files/ferm.conf
    - require_in:
      - file: ferm

{{ backup.dir('weechat', '/var/lib/weechat') }}
