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
    - name: glusterfs
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

#glusterfs.volume:
#  glusterfs.created:
#    - name: test
#    - bricks: {% for node in pillar['cluster']['nodes'] if node != grains['id'] %}
#      - {{ node }}:/srv/glusterfs/test
#      {%- endfor %}
#    - start: True
#    - require:
#      - service: glusterfs
#      - glusterfs: glusterfs.peers

