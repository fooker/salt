freifunk.qemu:
  pkg.installed:
    - name: qemu

freifunk.qemu.network:
  file.managed:
    - name: /etc/qemu/bridge.conf
    - contents: |
        allow int.fffd.m
        allow int.fffd.d
        allow int.open

freifunk.qemu.service:
  file.managed:
    - name: /etc/systemd/system/freifunk.service
    - source: salt://router/freifunk.service
    - makedirs: True
  service.running:
    - enable: True
    - name: freifunk
    - require:
      - pkg: freifunk.qemu
      - file: /etc/systemd/network/60-int.fffd.mesh.network
      - file: /etc/systemd/network/60-int.fffd.data.network
    - watch:
      - file: /etc/qemu/bridge.conf
      - file: /etc/systemd/system/freifunk.service

freifunk.network.mesh.network:
  file.managed:
    - name: /etc/systemd/network/60-int.fffd.mesh.network
    - source: salt://router/networkd.int.fffd.mesh.network
    - makedirs: True

freifunk.network.data.network:
  file.managed:
    - name: /etc/systemd/network/60-int.fffd.data.network
    - source: salt://router/networkd.int.fffd.data.network
    - makedirs: True

freifunk.dnsmasq:
  file.managed:
    - name: /etc/dnsmasq.conf.d/freifunk.conf
    - source: salt://router/dnsmasq.freifunk.conf
    - makedirs: True

freifunk.ferm:
  file.managed:
    - name: /etc/ferm.d/freifunk.conf
    - source: salt://router/ferm.freifunk.conf
    - makedirs: True
