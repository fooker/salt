network:
  service.running:
    - enable: True
    - name: systemd-networkd
    - watch:
      - file: /etc/systemd/network/*


resolve:
  file.symlink:
    - name: /etc/resolv.conf
    - target: /run/systemd/resolve/resolv.conf
    - force: True
  service.running:
    - enable: True
    - name: systemd-resolved
    - watch:
      - file: /etc/systemd/resolved.conf
      - file: /etc/systemd/network/*.network
      - service: systemd-networkd


resolve.conf:
  file.managed:
    - name: /etc/systemd/resolved.conf
    - contents: |
        [Resolve]
        LLMNR=no
{% if grains['role'] == 'gateway' %}
        Domains=mngt.int.{{ pillar.domain.name }} priv.int.{{ pillar.domain.name }} open.int.{{ pillar.domain.name }}
        DNS=127.0.0.1
{% else %}
        #FallbackDNS=
{% endif %}
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


{% if 'major' in pillar['addresses'][grains['id']]['int'] %}
network.int.major.network:
  file.managed:
    - name: /etc/systemd/network/60-int.major.network
    - source: salt://network/networkd.int.major.network.tmpl
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
