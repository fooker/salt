loophole.hs.network:
  file.managed:
    - name: /etc/systemd/network/80-hs.network
    - source: salt://loophole/files/networkd.hs.network.j2
    - template: jinja
    - makedirs: True
    - require_in:
      - file: network

loophole.ferm:
  file.managed:
    - name: /etc/ferm.d/loophole.conf
    - source: salt://loophole/files/ferm.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: ferm
