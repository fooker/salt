{% import 'rsnapshot/target/init.sls' as rsnapshot %}


include:
  - cluster


glusterfs.patch:
  # This is a patch for saltstack to make it work with glusterfs >= 3.7
  # See https://github.com/saltstack/salt/issues/28193
  file.replace:
    - name: /usr/lib/python2.7/site-packages/salt/modules/glusterfs.py
    - pattern: 'port, online'
    - repl: 'port, port_rdma, online'

glusterfs:
  pkg.installed:
    - pkgs:
      - rpcbind
      - glusterfs
  service.running:
    - enable: True
    - name: glusterd
    - require:
      - pkg: glusterfs
    - watch:
      - pkg: glusterfs

glusterfs.peers:
  glusterfs.peered:
    - names: {% for node in pillar['cluster']['nodes'] if node != grains['id'] %}
      - {{ node }}
      {%- endfor %}
    - require:
      - service: glusterfs

glusterfs.snmpd.conf:
  file.managed:
    - name: /etc/snmp/snmpd.conf.d/glusterfs.conf
    - source: salt://glusterfs/snmp.conf
    - makedirs: True

{% macro volume(module, mount, backup=True) %}
glusterfs.volume.{{ module }}:
  glusterfs.created:
    - name: {{ module }}
    - bricks: {% for node in pillar['cluster']['nodes'] %}
      - {{ node }}:/srv/glusterfs/{{ module }}
      {%- endfor %}
    - start: True
    - force: True
    - require:
      - service: glusterfs
      - glusterfs: glusterfs.peers
glusterfs.volume.{{ module }}.mounted:
  glusterfs.started:
    - name: {{ module }}
    - require:
      - glusterfs: glusterfs.volume.{{ module }}
  mount.mounted:
    - name: {{ mount }}
    - fstype: glusterfs
    - mkmnt: True
    - device: localhost:{{ module }}
    - require:
      - glusterfs: glusterfs.volume.{{ module }}.mounted

{% if backup %}
{{ rsnapshot.target('data.' + module, mount) }}
{% endif %}
{% endmacro %}

