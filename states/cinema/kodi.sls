include:
  - cinema

cinema.kodi:
  pkg.installed:
    - pkgs:
      - kodi
      - kodi-addon-adsp-basic
      - kodi-addon-adsp-biquad-filters
      - kodi-addon-adsp-freesurround
      - kodi-addon-audioencoder-flac
      - kodi-addon-audioencoder-lame
      - kodi-addon-audioencoder-vorbis
      - kodi-addon-audioencoder-wav
      - kodi-addon-peripheral-joystick
      - kodi-addon-screensaver-asteroids
      - kodi-addon-screensaver-asterwave
      - kodi-addon-screensaver-biogenesis
      - kodi-addon-screensaver-cpblobs
      - kodi-addon-screensaver-greynetic
      - kodi-addon-screensaver-matrixtrails
      - kodi-addon-screensaver-pingpong
      - kodi-addon-screensaver-pyro
      - kodi-addon-screensaver-rsxs
      - kodi-addon-screensaver-stars
      - kodi-addon-visualization-fishbmc
      - kodi-addon-visualization-goom
      - kodi-addon-visualization-projectm
      - kodi-addon-visualization-shadertoy
      - kodi-addon-visualization-spectrum
      - kodi-addon-visualization-waveform

      - libnfs
      - libplist
      - lirc

      - pulseaudio
      - shairplay

  user.present:
    - name: kodi
    - home: /var/lib/kodi
    - shell: /sbin/nologin
    - groups:
      - audio
      - video
      - network
      - optical

  file.managed:
    - name: /etc/systemd/system/kodi.service
    - source: salt://cinema/kodi.service
    - makedirs: True

  service.running:
    - enable: True
    - name: kodi
    - require:
      - pkg: cinema.kodi
      - pkg: cinema.xorg
    - watch:
      - file: cinema.kodi

