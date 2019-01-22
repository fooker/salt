include:
  - nfs/server


nas.hdparm:
  pkg.installed:
    - name: hdparm
  
  file.managed:
    - name: /etc/udev/rules.d/69-hdparm.rules
    - source: salt://nas/files/hdparm.rules
    - makedirs: True

nas.nfs:
  file.managed:
    - name: /etc/exports.d/vault.exports
    - source: salt://nas/files/exports
    - makedirs: True
    - require_in:
      - file: nfs.server
