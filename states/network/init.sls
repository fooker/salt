network:
  service:
    - running
    - enable: True
    - name: systemd-networkd
    - watch:
      - file: /etc/systemd/network/*


resolve:
  file:
    - symlink
    - name: /etc/resolv.conf
    - target: /run/systemd/resolve/resolv.conf
    - force: True
  service:
    - running
    - enable: True
    - name: systemd-resolved
    - watch:
      - file: /etc/systemd/resolved.conf
      - file: /etc/systemd/network/*.network


resolve.conf:
  file:
    - managed
    - name: /etc/systemd/resolved.conf
    - contents: |
        [Resolve]
        LLMNR=no
    - makedirs: True


{% if 'mngt' in pillar['addresses'][grains['id']]['int'] %}
network.int.mngt.network:
  file:
    - managed
    - name: /etc/systemd/network/60-int.mngt.network
    - source: salt://network/networkd.int.mngt.network.tmpl
    - template: jinja
{% endif %}


{% if 'priv' in pillar['addresses'][grains['id']]['int'] %}
network.int.priv.network:
  file:
    - managed
    - name: /etc/systemd/network/60-int.priv.network
    - source: salt://network/networkd.int.priv.network.tmpl
    - template: jinja
{% endif %}


{% if 'open' in pillar['addresses'][grains['id']]['int'] %}
network.int.open.network:
  file:
    - managed
    - name: /etc/systemd/network/60-int.open.network
    - source: salt://network/networkd.int.open.network.tmpl
    - template: jinja
{% endif %}


{% if 'ext' in pillar['addresses'][grains['id']] %}
network.ext.network:
  file:
    - managed
    - name: /etc/systemd/network/70-ext.network
    - source: salt://network/networkd.ext.network.tmpl
    - template: jinja
{% endif %}
