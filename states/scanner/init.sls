scanner.driver:
  pkg.installed:
    - sources:
      - brscan4: salt://scanner/brscan4-0.4.3_3-1-x86_64.pkg.tar.xz
      - brscan-skey: salt://scanner/brscan-skey-0.2.4_1-11-x86_64.pkg.tar.xz
  file.managed:
    - name: /etc/sane.d/dll.conf
    - contents: |
        brother4

scanner.button:
  file.managed:
    - name: /opt/brother/scanner/brscan-skey/brscan-skey-0.2.4-0.cfg
    - contents: |
        FILE="sh /usr/local/bin/scandoc"
  service.running:
    - enable: True
    - name: brscan-skey
    - required:
      - file: /opt/brother/scanner/brscan-skey/brscan-skey-0.2.4-0.cfg
      - file: /usr/local/bin/scandoc
      - pkg: brscan-skey

scanner.adacta:
  pkg.installed:
    - pkgs:
      - sane-frontends
      - unpaper
      - imagemagick
      - tesseract
      - tesseract-data-deu
      - poppler
  file.managed:
    - name: /usr/local/bin/scandoc
    - source: salt://scanner/scandoc
    - mode: 755

