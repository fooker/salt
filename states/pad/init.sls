
pad:
  pkg.installed:
    - pkgs:
      - pamixer
      - mpc
  file.managed:
    - name: /opt/pinup
    - source: salt://pad/files/pinup-{{ grains.cpuarch }}-bc61166
    - mode: 755

pad.config:
  file.managed:
    - name: /etc/pinup.yaml
    - source: salt://pad/files/pinup.yaml

pad.service:
  file.managed:
    - name: /usr/local/systemd/system/pinup.service
    - source: salt://pad/files/pinup.service
    - makedirs: True
    - require_in:
      - file: systemd.system
  service.running:
    - name: pinup
    - enable: True
    - watch:
      - file: pad
      - file: pad.service
      - file: pad.config
