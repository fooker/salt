nas.hdparm:
  pkg.installed:
    - name: hdparm
  
  file.managed:
    - name: /etc/udev/rules.d/69-hdparm.rules
    - source: salt://nas/files/hdparm.rules
    - makedirs: True
