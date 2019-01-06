{% import 'rsnapshot/target/init.sls' as rsnapshot %}
{% import 'nginx/init.sls' as nginx %}


include:
  - nginx


homeassistant:
  user.present:
    - name: homeassistant
    - shell: /usr/bin/nologin
    - home: /var/lib/homeassistant
    - createhome: True
    - system: True
  pkg.installed:
    - pkgs:
      - python-pip
      - python2-pip
  pip.installed:
    - name: 'homeassistant'
    - user: homeassistant
    - bin_env: '/usr/bin/pip3'
    - install_options:
      - --user
    - require:
      - pkg: homeassistant
      - user: homeassistant
  file.managed:
    - name: /usr/local/lib/systemd/system/homeassistant.service
    - source: salt://homeassistant/files/homeassistant.service
    - makedirs: True
    - require_in:
      - file: systemd.system
  service.running:
    - enable: True
    - require:
      - file: homeassistant
      - pip: homeassistant
      - user: homeassistant
      - file: homeassistant.config
    - watch:
      - file: homeassistant
      - pip: homeassistant
      - file: homeassistant.config

homeassistant.config:
  file.recurse:
    - name: /var/lib/homeassistant/config
    - source: salt://homeassistant/files/config
    - user: homeassistant
    - mkdirs: True
    - template: jinja
    - clean: True
    - exclude_pat: E@(deps)|(home-assistant.log)|(home-assistant_v2.db)|(.HA_VERSION)
    - require:
      - user: homeassistant



{{ nginx.vhost('homeassistant', source='salt://homeassistant/files/nginx.conf.j2', domains=['hass'], ssl=False, target='127.0.0.1:6680') }}

{{ rsnapshot.target('homeassistant', '/var/lib/homeassistant/') }}