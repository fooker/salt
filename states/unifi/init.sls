{% import 'backup/client/init.sls' as backup %}

unifi:
  pkg.installed:
    - name: unifi
  service.running:
    - enable: True
    - name: unifi
    - require:
      - pkg: unifi
    - watch:
      - file: /etc/ssh/sshd_config

{{ backup.dir('unifi', '/var/lib/unifi') }}

