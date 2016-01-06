{% for node in pillar['cluster']['nodes'] %}
cluster.lookup.{{ node }}:
  host.present:
    - name: {{ node }}
    - ip:
      - {{ pillar['addresses'][node]['int']['mngt']['ip4'] }}
{%- endfor %}

