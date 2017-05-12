include:
  - peering


{% for node in pillar.peering.interfaces if 'hive' in pillar.peering.interfaces[node] %}
hive.lookup.{{ node }}:
  host.present:
    - name: {{ node }}
    - ip:
      - {{ pillar.peering.interfaces[node].hive.ip4.address }}
      - {{ pillar.peering.interfaces[node].hive.ip6.address }}
{%- endfor %}


hive.iptables:
  file.managed:
    - name: /etc/ferm.d/hive.conf
    - source: salt://hive/ferm.conf.tmpl
    - makedirs: True
    - template: jinja
    - require_in:
      - file: ferm

