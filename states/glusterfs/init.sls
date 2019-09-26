# Volume containing brick should be formated with `mkfs.xfs -f -i size=512 -n size=8192 -d su=128K,sw=10 /dev/mapper/data`

{% import 'backup/client/init.sls' as backup %}


glusterfs:
  pkg.installed:
    - name: glusterfs
  
  service.running:
    - name: glusterd
    - enable: True
    - require:
      - pkg: glusterfs

{% for node in pillar.hive.nodes if node != grains.id %}
glusterfs.peered.{{ node }}:
  glusterfs.peered:
    - name: {{ pillar.addresses[node].hive.ip4.address }}
    - require:
      - service: glusterfs
{% endfor %}

{% for volume in pillar.hive.volumes %}
glusterfs.volume.{{ volume }}:
  glusterfs.volume_present:
    - name: {{ volume }}
    - bricks:
      {% for node in pillar.hive.nodes %}
      - {{ pillar.addresses[node].hive.ip4.address }}:/srv/glusterfs/{{ volume }}
      {% endfor %}
    - replica: {{ pillar.hive.nodes|count }}
    - start: True
{% endfor %}

glusterfs.iptables:
  file.managed:
    - name: /etc/ferm.d/glusterfs.conf
    - source: salt://glusterfs/files/ferm.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: ferm
