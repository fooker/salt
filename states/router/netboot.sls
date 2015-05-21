include:
  - router.dnsmasq

tftp.dnsmasq:
  file:
    - managed
    - name: /etc/dnsmasq.conf.d/tftp.conf
    - source: salt://router/dnsmasq.tftp.conf
    - makedirs: True

tftp.mount:
  mount:
    - mounted
    - name: /srv/tftp
    - device: nas:/mnt/files/netboot
    - fstype: nfs4
    - opts: nolock
    - mkmnt: True
    - persist: True
    - mount: True

tftp.ferm:
  file:
    - managed
    - name: /etc/ferm.d/tftp.conf
    - source: salt://router/ferm.tftp.conf
    - makedirs: True

