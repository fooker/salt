include:
  - iptables


pulseaudio:
  pkg.installed:
    - pkgs:
      - pulseaudio
      - pulseaudio-alsa
  file.managed:
    - name: /etc/pulse/system.pa
    - source: salt://pulseaudio/files/pulseaudio.system.pa.j2
    - makedirs: True
    - template: jinja

pulseaudio.service:
  file.managed:
    - name: /usr/local/systemd/system/pulseaudio.service
    - source: salt://pulseaudio/files/pulseaudio.service
    - makedirs: True
    - require_in:
      - file: systemd.system

  service.running:
    - name: pulseaudio
    - enable: True
    - require:
      - pkg: pulseaudio
      - file: pulseaudio.service
      - file: pulseaudio

pulseaudio.ferm:
  file.managed:
    - name: /etc/ferm.d/50-pulseaudio.conf
    - source: salt://pulseaudio/files/ferm.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: ferm
