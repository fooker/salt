{% import 'rsnapshot/target/init.sls' as rsnapshot %}
{% import 'nginx/init.sls' as nginx %}


include:
  - nginx


aurblobs:
  user.present:
    - name: aurblobs
    - shell: /usr/bin/nologin
    - home: /var/lib/aurblobs
    - createhome: True
    - system: True
  pkg.installed:
    - pkgs:
      - python-pip
      - python2-pip
  pip.installed:
    - name: 'git+https://github.com/aurblobs/aurblobs.git@develop'
    - user: aurblobs
    - bin_env: '/usr/bin/pip3'
    - upgrade: True
    - use_wheel: True
    - install_options:
      - --user
    - require:
      - pkg: aurblobs
      - user: aurblobs


{{ nginx.vhost('aurblobs', source='salt://aurblobs/files/nginx.conf.j2', domains=['aurblobs.open-desk.net']) }}
{{ nginx.vhost('aurblobs.to_ssl', source='salt://nginx/files/vhost/redirect-ssl.conf.j2', ssl=False, domains=['aurblobs.open-desk.net']) }}

{{ rsnapshot.target('aurblobs', '/var/lib/aurblobs/.config/aurblobs', '/var/lib/aurblobs/.gnupg') }}
