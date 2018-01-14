mopidy:
  pkg.installed:
    - name: mopidy

  file.managed:
    - name: /etc/mopidy/mopidy.conf
    - source: salt://blaster/mopidy.conf
    - makedirs: True

  service.running:
    - enable: True
    - name: mopidy
    - watch:
      - pkg: mopidy
      - file: mopidy

pulseaudio:
  pkg.installed:
    - name: pulseaudio

