{% for name, value in pillar['sysctl'].items() -%}
sysctl.{{ name }}:
  sysctl.present:
    - name: {{ name }}
    - value: {{ value }}
    - config: /etc/sysctl.d/60-common.conf
{% endfor %}
