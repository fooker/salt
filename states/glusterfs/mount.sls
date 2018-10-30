{% for volume in pillar.hive.volumes %}
glusterfs.mount.{{ volume }}:
  mount.mounted:
    - name: {{ pillar.hive.volumes[volume].mountpoint }}
    - device: {{ pillar.hive.nodes|join(',') }}:/{{ volume }}
    - fstype: glusterfs
    - opts: _netdev,rw,defaults,direct-io-mode=disable
    - mkmnt: True
    - persist: True
    - dump: 0
    - pass_num: 0
{% endfor %}
  