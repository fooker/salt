{% import 'nginx/init.sls' as nginx %}


include:
  - pulseaudio
  - nginx


mopidy:
  pkg.installed:
    - pkgs:
      - mopidy
      - gstreamer
      - gst-plugins-good
      - gst-plugins-bad
      - gst-plugins-ugly
      - nfs-utils

  file.managed:
    - name: /etc/mopidy/mopidy.conf
    - source: salt://mopidy/files/mopidy.conf.j2
    - makedirs: True
    - template: jinja

  service.running:
    - enable: True
    - name: mopidy
    - watch:
      - pkg: mopidy
      - file: mopidy

mopidy.media:
  mount.mounted:
    - name: '/media'
    - device: '{{ pillar.addresses['nas'].int.priv.ip4 }}:/media'
    - fstype: nfs4
    - persist: True
    - mkmnt: True
    - opts:
      - ro,noatime,_netdev

{{ nginx.vhost('mopidy', source='salt://mopidy/files/nginx.conf.j2', domains=['music'], ssl=False, target='127.0.0.1:6680') }}
