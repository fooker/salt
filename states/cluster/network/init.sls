{% macro address_ip4(node) -%}
{{ '%s.%d' | format(
    pillar['cluster']['network']['prefix']['ip4'],
    pillar['cluster']['nodes'].index(node)
) }}
{%- endmacro %}

{% macro address_ip6(node) -%}
{{ '%s::%x' | format(
    pillar['cluster']['network']['prefix']['ip6'],
    pillar['cluster']['nodes'].index(node)
) }}
{%- endmacro %}


cluster.network.ipsec:
  pkg.installed:
    - name: strongswan
    - sources:
      - strongswan: salt://cluster/network/strongswan-5.4.0-2-x86_64.pkg.tar.xz
  service.running:
    - enable: True
    - name: strongswan
    - require:
      - pkg: strongswan
    - watch:
      - file: /etc/ipsec.conf
      - file: /etc/ipsec.secrets

cluster.network.ipsec.conf:
  file.managed:
    - name: /etc/ipsec.conf
    - source: salt://cluster/network/ipsec.conf.tmpl
    - makedirs: True
    - template: jinja

cluster.network.ipsec.secrets:
  file.managed:
    - name: /etc/ipsec.secrets
    - source: salt://cluster/network/ipsec.secrets.tmpl
    - makedirs: True
    - template: jinja

cluster.network.iptables:
  kmod.present:
    - name: nf_conntrack_proto_gre
    - persist: True
  file.managed:
    - name: /etc/ferm.d/cluster.conf
    - source: salt://cluster/network/ferm.conf
    - makedirs: True
    - requires:
      - kmod: nf_conntrack_proto_gre

{% for node in pillar['cluster']['nodes'] if node != grains['id'] %}
cluster.network.tunnel.{{ node }}.netdev:
  file.managed:
    - name: /etc/systemd/network/80-cluster-{{ node }}.netdev
    - source: salt://cluster/network/networkd.netdev.tmpl
    - makedirs: True
    - template: jinja
    - context:
        remote: {{ node }}

cluster.network.tunnel.{{ node }}.hook:
  file.accumulated:
    - name: tunnels
    - filename: /etc/systemd/network/70-ext.network
    - text: cluster-{{ pillar['cluster']['nodes'].index(node) }}
    - require_in:
      - file: network.ext.network

cluster.network.tunnel.{{ node }}.network:
  file.managed:
    - name: /etc/systemd/network/80-cluster-{{ node }}.network
    - source: salt://cluster/network/networkd.network.tmpl
    - makedirs: True
    - template: jinja
    - context:
        remote: {{ node }}
{%- endfor %}

clustern.network.forwarding.ipv4:
  sysctl.present:
    - name: net.ipv4.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/cluster.conf

clustern.network.forwarding.ipv6:
  sysctl.present:
    - name: net.ipv6.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/cluster.conf

{% for node in pillar['cluster']['nodes'] %}
cluster.network.lookup.{{ node }}:
  host.present:
    - name: {{ node }}
    - ip:
      - {{ address_ip4(node) }}
      - {{ address_ip6(node) }}
{%- endfor %}

