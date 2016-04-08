network:
  service.running:
    - enable: True
    - name: systemd-networkd
    - watch:
      - file: /etc/systemd/network/*


resolve:
{% if grains['role'] != 'gateway' %}
  file.symlink:
    - name: /etc/resolv.conf
    - target: /run/systemd/resolve/resolv.conf
    - force: True
  service.running:
    - enable: True
    - name: systemd-resolved
    - watch:
      - file: /etc/systemd/resolved.conf
      - service: systemd-networkd
{% else %}
  file.managed:
    - name: /etc/resolv.conf
    - contents: |
        nameserver 127.0.0.1
        nameserver ::1
{% endif %}


resolve.conf:
  file.managed:
    - name: /etc/systemd/resolved.conf
    - contents: |
        [Resolve]
        LLMNR=no
        #FallbackDNS=
    - makedirs: True

nsswitch.conf:
  file.replace:
    - name: /etc/nsswitch.conf
    - pattern: '^hosts: .*$'
    - repl: 'hosts: files mymachines resolve myhostname'

{% if 'int' in pillar['addresses'][grains['id']] %}
{% if 'mngt' in pillar['addresses'][grains['id']]['int'] %}
network.int.mngt.network:
  file.managed:
    - name: /etc/systemd/network/60-int.mngt.network
    - source: salt://network/networkd.int.mngt.network.tmpl
    - template: jinja
    - makedirs: True
{% endif %}


{% if 'priv' in pillar['addresses'][grains['id']]['int'] %}
network.int.priv.network:
  file.managed:
    - name: /etc/systemd/network/60-int.priv.network
    - source: salt://network/networkd.int.priv.network.tmpl
    - template: jinja
    - makedirs: True
{% endif %}


{% if 'open' in pillar['addresses'][grains['id']]['int'] %}
network.int.open.network:
  file.managed:
    - name: /etc/systemd/network/60-int.open.network
    - source: salt://network/networkd.int.open.network.tmpl
    - template: jinja
    - makedirs: True
{% endif %}
{% endif %}


{% if 'ffx' in pillar['addresses'][grains['id']] %}
{% if 'data' in pillar['addresses'][grains['id']]['ffx'] %}
network.ffx.data.network:
  file.managed:
    - name: /etc/systemd/network/70-ffx.data.network
    - source: salt://network/networkd.ffx.data.network.tmpl
    - template: jinja
    - makedirs: True
{% endif %}
{% endif %}


{% if 'ext' in pillar['addresses'][grains['id']] %}
network.ext.network:
  file.managed:
    - name: /etc/systemd/network/70-ext.network
    - source: salt://network/networkd.ext.network.tmpl
    - template: jinja
    - makedirs: True
{% endif %}
