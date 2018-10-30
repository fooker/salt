include:
  - peering


{% for node in pillar.hive.nodes %}
hive.lookup.{{ node }}:
  host.present:
    - name: {{ node }}
    - ip:
      - {{ pillar.addresses[node].hive.ip4.address }}
      - {{ pillar.addresses[node].hive.ip6.address }}
{%- endfor %}

hive.iptables:
  file.managed:
    - name: /etc/ferm.d/hive.conf
    - source: salt://hive/files/ferm.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: ferm

