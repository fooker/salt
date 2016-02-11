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


cluster.net.ipsec:
  pkg.installed:
    - name: strongswan
    - sources:
      - strongswan: salt://cluster/strongswan-5.3.5-1-x86_64.pkg.tar.xz
  service.running:
    - enable: True
    - name: strongswan
    - require:
      - pkg: strongswan
    - watch:
      - file: /etc/ipsec.conf
      - file: /etc/ipsec.secrets

cluster.net.ipsec.conf:
  file.managed:
    - name: /etc/ipsec.conf
    - source: salt://cluster/ipsec.conf.tmpl
    - makedirs: True
    - template: jinja

cluster.net.ipsec.secrets:
  file.managed:
    - name: /etc/ipsec.secrets
    - source: salt://cluster/ipsec.secrets.tmpl
    - makedirs: True
    - template: jinja

cluster.net.iptables:
  kmod.present:
    - name: nf_conntrack_proto_gre
    - persist: True
  file.managed:
    - name: /etc/ferm.d/cluster.conf
    - source: salt://cluster/ferm.conf
    - makedirs: True
    - requires:
      - kmod: nf_conntrack_proto_gre

{% for node in pillar['cluster']['nodes'] if node != grains['id'] %}
cluster.net.tunnel.{{ node }}.netdev:
  file.managed:
    - name: /etc/systemd/network/80-cluster-{{ node }}.netdev
    - source: salt://cluster/networkd.netdev.tmpl
    - makedirs: True
    - template: jinja
    - context:
        remote: {{ node }}

cluster.net.tunnel.{{ node }}.hook:
  file.accumulated:
    - name: tunnels
    - filename: /etc/systemd/network/70-ext.network
    - text: cluster-{{ pillar['cluster']['nodes'].index(node) }}
    - require_in:
      - file: network.ext.network
{%- endfor %}

cluster.net.tunnel.network:
  file.managed:
    - name: /etc/systemd/network/80-cluster.network
    - source: salt://cluster/networkd.network.tmpl
    - makedirs: True
    - template: jinja

cluster.net.routing:
  pkg.installed:
    - name: babeld
    - sources:
      - babeld: salt://cluster/babeld-1.6.3-1-x86_64.pkg.tar.xz
  service.running:
    - enable: True
    - name: babeld
    - require:
      - pkg: babeld
    - watch:
      - file: /etc/babeld.conf
  file.managed:
    - name: /etc/babeld.conf
    - source: salt://cluster/babeld.conf.tmpl
    - makedirs: True
    - template: jinja

{% for node in pillar['cluster']['nodes'] %}
cluster.lookup.{{ node }}:
  host.present:
    - name: {{ node }}
    - ip:
      - {{ address_ip4(node) }}
      - {{ address_ip6(node) }}
{%- endfor %}

