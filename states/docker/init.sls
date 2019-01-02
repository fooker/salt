docker:
  pkg.installed:
    - pkgs:
      - docker
  file.managed:
    - name: /etc/docker/daemon.json
    - source: salt://docker/files/daemon.json.j2
    - makedirs: True
    - template: jinja
  service.running:
    - name: docker
    - enable: True
    - watch:
      - pkg: docker
      - file: docker

docker.iptables:
  file.managed:
    - name: /etc/ferm.d/docker.conf
    - source: salt://docker/files/ferm.conf.j2
    - template: jinja
    - require_in:
      - file: ferm
