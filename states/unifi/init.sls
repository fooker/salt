{% import 'rsnapshot/target/init.sls' as rsnapshot %}

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

{{ rsnapshot.target('unifi', '/var/lib/unifi') }}

