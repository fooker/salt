{% import 'rsnapshot/target/init.sls' as rsnapshot %}
{% import 'nginx/init.sls' as nginx %}


include:
  - docker
  - nginx


aurblobs:
  user.present:
    - name: aurblobs
    - shell: /usr/bin/nologin
    - home: /var/lib/aurblobs
    - createhome: True
    - system: True
    - groups:
      - docker
  pkg.installed:
    - pkgs:
      - python-pip
  pip.installed:
    - name: 'git+https://github.com/aurblobs/aurblobs.git@master'
    - user: aurblobs
    - bin_env: '/usr/bin/pip3'
    - install_options:
      - --user
    - require:
      - pkg: aurblobs
      - user: aurblobs

aurblobs.service:
  file.managed:
    - name: /usr/local/lib/systemd/system/aurblobs.service
    - source: salt://aurblobs/files/aurblobs.service
    - makedirs: True
    - require_in:
      - file: systemd.system

aurblobs.timer:
  file.managed:
    - name: /usr/local/lib/systemd/system/aurblobs.timer
    - source: salt://aurblobs/files/aurblobs.timer
    - makedirs: True
    - require_in:
      - file: systemd.system
  service.running:
    - enable: True
    - name: aurblobs.timer
    - watch:
      - pip: aurblobs
      - file: aurblobs.service
      - file: aurblobs.timer

{{ nginx.vhost('aurblobs', source='salt://aurblobs/files/nginx.conf.j2', domains=['aurblobs.open-desk.net']) }}
{{ nginx.vhost('aurblobs.to_ssl', source='salt://nginx/files/vhost/redirect-ssl.conf.j2', ssl=False, domains=['aurblobs.open-desk.net']) }}

{{ rsnapshot.target('aurblobs', '/var/lib/aurblobs/.config/aurblobs', '/var/lib/aurblobs/.gnupg') }}
