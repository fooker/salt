{% if grains['area'] != 'locum' -%}

{% for name, value in pillar['sysctl'].items() -%}
sysctl.{{ name }}:
  sysctl.present:
    - name: {{ name }}
    - value: {{ value }}
    - config: /etc/sysctl.d/common.conf
{% endfor %}

{%- endif %}
