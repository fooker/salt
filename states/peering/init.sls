peering.ipsec:
  pkg.installed:
    - name: strongswan
    - sources:
      - strongswan: salt://peering/strongswan-5.5.2-1-x86_64.pkg.tar.xz
  service.running:
    - enable: True
    - name: strongswan
    - require:
      - pkg: strongswan
    - watch:
      - file: /etc/ipsec.conf
      - file: /etc/ipsec.secrets

peering.ipsec.conf:
  file.managed:
    - name: /etc/ipsec.conf
    - source: salt://peering/ipsec.conf.tmpl
    - makedirs: True
    - template: jinja

peering.ipsec.secrets:
  file.managed:
    - name: /etc/ipsec.secrets
    - source: salt://peering/ipsec.secrets.tmpl
    - makedirs: True
    - template: jinja

peering.iptables:
  kmod.present:
    - name: nf_conntrack_proto_gre
    - persist: True
  file.managed:
    - name: /etc/ferm.d/peering.conf
    - source: salt://peering/ferm.conf.tmpl
    - makedirs: True
    - template: jinja
    - require:
      - kmod: nf_conntrack_proto_gre
    - require_in:
      - file: ferm

{% for domain in pillar.peering.interfaces[grains.id] %}
peering.domain.{{ domain }}.netdev:
  file.managed:
    - name: /etc/systemd/network/90-peering-{{ domain }}.netdev
    - source: salt://peering/networkd.domain.netdev.tmpl
    - makedirs: True
    - template: jinja
    - context:
        domain: {{ domain }}

peering.domain.{{ domain }}.network:
  file.managed:
    - name: /etc/systemd/network/90-peering-{{ domain }}.network
    - source: salt://peering/networkd.domain.network.tmpl
    - makedirs: True
    - template: jinja
    - context:
        domain: {{ domain }}
{% endfor %}

{% for peer in pillar.peering.transfers[grains.id] %}
peering.tunnel.{{ peer }}.netdev:
  file.managed:
    - name: /etc/systemd/network/80-peering-{{ peer }}.netdev
    - source: salt://peering/networkd.tunnel.{{ pillar.peering.peers[peer].type }}.netdev.tmpl
    - makedirs: True
    - template: jinja
    - context:
        peer: {{ peer }}

peering.tunnel.{{ peer }}.network:
  file.managed:
    - name: /etc/systemd/network/80-peering-{{ peer }}.network
    - source: salt://peering/networkd.tunnel.network.tmpl
    - makedirs: True
    - template: jinja
    - context:
        peer: {{ peer }}

peering.tunnel.{{ peer }}.hook:
  file.accumulated:
    - name: tunnels
    - filename: /etc/systemd/network/70-ext.network
    - text: peer.{{ pillar.peering.peers[peer].netdev }}
    - require_in:
      - file: network.ext.network

peering.ipsec.certs.{{ peer }}:
  file.managed:
    - name: /etc/ipsec.d/certs/{{ peer }}.pem
    - contents_pillar: peering:peers:{{ peer }}:pubkey
    - makedirs: True
{%- endfor %}

peering.sysctl.forwarding.ipv4:
  sysctl.present:
    - name: net.ipv4.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/peering.conf

peering.sysctl.forwarding.ipv6:
  sysctl.present:
    - name: net.ipv6.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/peering.conf

peering.sysctl.rp_filter:
  sysctl.present:
    - name: net.ipv4.conf.all.rp_filter
    - value: 0
    - config: /etc/sysctl.d/peering.conf

peering.bird:
  pkg.installed:
    - name: bird
  service.running:
    - name: bird
    - enable: True
    - reload: True
    - require:
      - pkg: peering.bird
    - watch:
      - file: /etc/bird.conf
  file.managed:
    - name: /etc/bird.conf
    - source: salt://peering/bird.conf.tmpl
    - makedirs: True
    - template: jinja

peering.bird6:
  pkg.installed:
    - name: bird6
  service.running:
    - name: bird6
    - enable: True
    - reload: True
    - require:
      - pkg: peering.bird6
    - watch:
      - file: /etc/bird6.conf
  file.managed:
    - name: /etc/bird6.conf
    - source: salt://peering/bird6.conf.tmpl
    - makedirs: True
    - template: jinja

