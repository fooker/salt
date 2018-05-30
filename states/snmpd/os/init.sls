include:
  - snmpd

snmpd.conf.os:
  file.managed:
    - name: /etc/snmp/snmpd.conf.d/os.conf
    - source: salt://snmpd/os/files/snmpd.conf
    - makedirs: True

snmpd.extends.os.pacman:
  file.managed:
    - name: /etc/snmp/extends/os.updates
    - source: salt://snmpd/os/files/updates.extend
    - makedirs: True
    - mode: 755

snmpd.extends.os.pacman.hook:
  file.managed:
    - name: /etc/pacman.d/hooks/snmp-os.updates.hook
    - source: salt://snmpd/os/files/updates.hook
    - makedirs: True

