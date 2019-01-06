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
  file.managed:
    - name: /usr/local/lib/systemd/system/mopidy.service.d/mount.conf
    - makedirs: True
    - contents: |
        ### This file is managed by saltstack - any changes will be overwritten ###
        [Unit]
        RequiresMountsFor=/media/music
    - watch_in:
      - service: mopidy
    - require_in:
      - file: systemd.system

{{ nginx.vhost('mopidy', source='salt://mopidy/files/nginx.conf.j2', domains=['music'], ssl=False, target='127.0.0.1:6680') }}
