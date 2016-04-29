{% import 'rsnapshot/target/init.sls' as rsnapshot %}


cluster.storage.patch:
  # This is a patch for saltstack to make it work with glusterfs >= 3.7
  # See https://github.com/saltstack/salt/issues/28193
  file.replace:
    - name: /usr/lib/python2.7/site-packages/salt/modules/glusterfs.py
    - pattern: 'port, online'
    - repl: 'port, port_rdma, online'

cluster.storage:
  pkg.installed:
    - pkgs:
      - rpcbind
      - glusterfs
  service.running:
    - enable: True
    - name: glusterd
    - require:
      - pkg: cluster.storage

cluster.storage.storage:
  mount.mounted:
    - name: /srv/glusterfs
    - fstype: ext4
    - mkmnt: True
    - device: /dev/mapper/data
    - opts:
      - rw
      - noatime

cluster.storage.peers:
  glusterfs.peered:
    - names: {% for node in pillar['cluster']['nodes'] if node != grains['id'] %}
      - {{ node }}
      {%- endfor %}
    - require:
      - service: cluster.storage

{% macro volume(module, mount, backup=True) %}
cluster.storage.volume.{{ module }}:
  glusterfs.created:
    - name: {{ module }}
    - bricks: {% for node in pillar['cluster']['nodes'] %}
      - {{ node }}:/srv/glusterfs/{{ module }}
      {%- endfor %}
    - start: True
    - replica: {{ pillar['cluster']['nodes'] | length }}
    - require:
      - service: cluster.storage
      - glusterfs: cluster.storage.peers
cluster.storage.volume.{{ module }}.mounted:
  glusterfs.started:
    - name: {{ module }}
    - require:
      - glusterfs: cluster.storage.volume.{{ module }}
  mount.mounted:
    - name: {{ mount }}
    - fstype: glusterfs
    - mkmnt: True
    - device: localhost:{{ module }}
    - require:
      - glusterfs: cluster.storage.volume.{{ module }}.mounted

{% if backup %}
{{ rsnapshot.target('data.' + module, mount) }}
{% endif %}
{% endmacro %}

