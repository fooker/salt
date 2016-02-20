snmpd.conf.os:
  file.managed:
    - name: /etc/snmp/snmpd.conf.d/os.conf
    - source: salt://snmp/os.conf
    - makedirs: True

snmpd.extends.os.pacman:
  file.managed:
    - name: /etc/snmp/extends/os.updates
    - source: salt://snmp/os.updates.extend
    - makedirs: True
    - mode: 755

snmpd.extends.os.pacman.hook:
  file.managed:
    - name: /etc/pacman.d/hooks/snmp-os.updates.hook
    - source: salt://snmp/os.updates.hook
    - makedirs: True

