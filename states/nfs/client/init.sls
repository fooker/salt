include:
  - nfs

{% macro mount(module, source, target) %}
nfs.client.mount.{{ module }}:
  mount.mounted:
    - name: {{ target }}
    - device: '{{ pillar.addresses.bunker.hive.ip4.address }}:/{{ source }}'
    - fstype: nfs4
    - mkmnt: True
    - opts: noatime,clientaddr={{ pillar.addresses[grains.id].hive.ip4.address }}
    - persist: True
{% endmacro %}
