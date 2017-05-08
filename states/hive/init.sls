{% macro address_ip4(node) -%}
{{ '%s.%d' | format(
    pillar['hive']['prefix']['ip4'],
    pillar['hive']['nodes'].index(node)
) }}
{%- endmacro %}

{% macro address_ip6(node) -%}
{{ '%s::%x' | format(
    pillar['hive']['prefix']['ip6'],
    pillar['hive']['nodes'].index(node)
) }}
{%- endmacro %}


hive.ipsec:
  pkg.installed:
    - name: strongswan
    - sources:
      - strongswan: salt://hive/strongswan-5.4.0-2-x86_64.pkg.tar.xz
  service.running:
    - enable: True
    - name: strongswan
    - require:
      - pkg: strongswan
    - watch:
      - file: /etc/ipsec.conf
      - file: /etc/ipsec.secrets

hive.ipsec.conf:
  file.managed:
    - name: /etc/ipsec.conf
    - source: salt://hive/ipsec.conf.tmpl
    - makedirs: True
    - template: jinja

hive.ipsec.secrets:
  file.managed:
    - name: /etc/ipsec.secrets
    - source: salt://hive/ipsec.secrets.tmpl
    - makedirs: True
    - template: jinja

hive.iptables:
  kmod.present:
    - name: nf_conntrack_proto_gre
    - persist: True
  file.managed:
    - name: /etc/ferm.d/hive.conf
    - source: salt://hive/ferm.conf
    - require:
      - kmod: nf_conntrack_proto_gre
    - require_in:
      - file: ferm

{% for node in pillar['hive']['nodes'] if node != grains['id'] %}
hive.tunnel.{{ node }}.netdev:
  file.managed:
    - name: /etc/systemd/network/80-hive-{{ node }}.netdev
    - source: salt://hive/networkd.netdev.tmpl
    - makedirs: True
    - template: jinja
    - context:
        remote: {{ node }}

hive.tunnel.{{ node }}.hook:
  file.accumulated:
    - name: tunnels
    - filename: /etc/systemd/network/70-ext.network
    - text: hive-{{ pillar['hive']['nodes'].index(node) }}
    - require_in:
      - file: network.ext.network

hive.tunnel.{{ node }}.network:
  file.managed:
    - name: /etc/systemd/network/80-hive-{{ node }}.network
    - source: salt://hive/networkd.network.tmpl
    - makedirs: True
    - template: jinja
    - context:
        remote: {{ node }}
{%- endfor %}

hive.forwarding.ipv4:
  sysctl.present:
    - name: net.ipv4.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/hive.conf

hive.forwarding.ipv6:
  sysctl.present:
    - name: net.ipv6.conf.all.forwarding
    - value: 1
    - config: /etc/sysctl.d/hive.conf

{% for node in pillar['hive']['nodes'] %}
hive.lookup.{{ node }}:
  host.present:
    - name: {{ node }}
    - ip:
      - {{ address_ip4(node) }}
      - {{ address_ip6(node) }}
{%- endfor %}

