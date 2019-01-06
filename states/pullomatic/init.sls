pullomatic.bin:
  file.managed:
    - name: /opt/pullomatic
    - source: https://github.com/fooker/pullomatic/releases/download/v0.1/pullomatic
    - source_hash: sha512=61e0766a706f65ebdd54cba0912a6b03c1c44a948cd00e5d92b06021eca4c23af637536e3e7d091504ec272f96a031ff3ca19569f44bb981a33361e68f71eaef
    - mode: 755
  pkg.installed:
    - pkgs:
      - libcurl-gnutls

pullomatic.service:
  file.managed:
    - name: /usr/local/systemd/system/pullomatic.service
    - source: salt://pullomatic/files/pullomatic.service
    - makedirs: True
    - require_in:
      - file: systemd.system

  service.running:
    - name: pullomatic
    - enable: True
    - require:
      - file: pullomatic.bin
      - file: pullomatic.service
    - watch:
      - file: pullomatic.bin
      - file: pullomatic.service
      - file: pullomatic

pullomatic:
  file.directory:
    - name: /etc/pullomatic
    - makedirs: True
    - clean: True
