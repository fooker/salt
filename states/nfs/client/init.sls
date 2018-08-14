include:
  - nfs

{% macro mount(module, source, target) %}
nfs.client.mount.{{ module }}:
  mount.mounted:
    - name: {{ target }}
    - device: 'bunker:/{{ source }}'
    - fstype: nfs4
    - mkmnt: True
    - opts: noatime,clientaddr={{ pillar.peering.interfaces[grains.id].hive.ip4.address }}
    - persist: True
{% endmacro %}
