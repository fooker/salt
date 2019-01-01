rdp-proxy.network:
  file.managed:
    - name: /etc/systemd/network/80-hs.network
    - source: salt://rdp-proxy/files/networkd.hs.network.j2
    - template: jinja
    - makedirs: True
    - require_in:
      - file: network

rdp-proxy.ferm:
  file.managed:
    - name: /etc/ferm.d/rdp-proxy.conf
    - source: salt://rdp-proxy/files/ferm.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: ferm
