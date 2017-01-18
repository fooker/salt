include:
  - nfs


{% macro mount(module, source, target) %}
nfs.client.mount.{{ module }}:
  mount.mounted:
    - name: {{ target }}
    - device: 'bunker://{{ source }}'
    - fstype: nfs4
    - mkmnt: True
    - opts: noatime
    - persist: True
{% endmacro %}

