scanner.sane:
  pkg.installed:
    - pkgs:
      - sane
      - sane-frontends
      - imagemagick
      - unpaper

scanner.sane.conf.dll:
  file.managed:
    - name: /etc/sane.d/dll.conf
    - source: salt://scanner/files/sane.dll.conf.j2
    - makedirs: True
    - template: jinja
    - require:
      - pkg: scanner.sane

scanner.sane.conf.net:
  file.managed:
    - name: /etc/sane.d/net.conf
    - source: salt://scanner/files/sane.net.conf.j2
    - makedirs: True
    - template: jinja
    - require:
      - pkg: scanner.sane

scanner.scanbd:
  pkg.installed:
    - sources:
      - scanbd: salt://scanner/files/scanbd-1.5.1-3-aarch64.pkg.tar.xz

scanner.scanbd.conf:
  file.managed:
    - name: /etc/scanbd/scanbd.conf
    - source: salt://scanner/files/scanbd.conf.j2
    - makedirs: True
    - template: jinja
    - require:
      - pkg: scanner.scanbd
    - watch_in:
      - service: scanner.scanbd.service

scanner.scanbd.scripts.scan:
  file.managed:
    - name: /etc/scanbd/scripts/scan.script
    - source: salt://scanner/files/scan.script
    - makedirs: True
    - mode: 755
    - template: jinja
    - require:
      - pkg: scanner.scanbd
    - watch_in:
      - service: scanner.scanbd.service

scanner.scanbd.conf.saned:
  file.managed:
    - name: /etc/scanbd/sane.d/saned.conf
    - source: salt://scanner/files/scanbd.saned.conf.j2
    - makedirs: True
    - template: jinja
    - require:
      - pkg: scanner.scanbd
    - watch_in:
      - service: scanner.scanbd.service

scanner.scanbd.conf.dll:
  file.managed:
    - name: /etc/scanbd/sane.d/dll.conf
    - source: salt://scanner/files/scanbd.dll.conf.j2
    - makedirs: True
    - template: jinja
    - require:
      - pkg: scanner.scanbd
    - watch_in:
      - service: scanner.scanbd.service

scanner.scanbd.conf.device:
  file.managed:
    - name: /etc/scanbd/sane.d/{{ pillar.scanner.driver }}.conf
    - source: /etc/sane.d/{{ pillar.scanner.driver }}.conf
    - makedirs: True
    - require:
      - pkg: scanner.scanbd
    - watch_in:
      - service: scanner.scanbd.service

scanner.scanbd.service:
  service.running:
    - enable: True
    - name: scanbd.service
    - watch:
      - pkg: scanner.scanbd

scanner.scanbm.service:
  service.running:
    - enable: True
    - name: scanbm.socket
    - watch:
      - pkg: scanner.scanbd
      - service: scanner.scanbd.service

scanner.ferm:
  file.managed:
    - name: /etc/ferm.d/scanner.conf
    - source: salt://scanner/files/ferm.conf.j2
    - makedirs: True
    - template: jinja
    - require_in:
      - file: ferm
