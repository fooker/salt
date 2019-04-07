include:
  - smb


smb.server:
  file.managed:
    - name: /etc/samba/smb.conf
    - source: salt://smb/server/files/smb.conf.j2
    - template: jinja
    - makedirs: True
    - watch_in:
      - service: smb.server

  service.running:
    - enable: True
    - name: smb
    - require:
      - pkg: smb

smb.iptables:
  file.managed:
    - name: /etc/ferm.d/smb.conf
    - source: salt://smb/server/files/ferm.conf
    - makedirs: True
    - require_in:
      - file: ferm
