sshd:
  pkg.installed:
    - name: openssh
  service.running:
    - enable: True
    - name: sshd
    - require:
      - pkg: openssh
    - watch:
      - file: /etc/ssh/sshd_config

sshd.conf:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://ssh/files/sshd.conf.j2
    - makedirs: True
    - template: jinja

{% for owner, key in pillar['ssh']['authorized_keys'].items() %}
sshd.root.authorized_keys.{{ owner }}:
  ssh_auth.present:
    - user: root
    - name: {{ key }}
    - comment: {{ owner }}
{% endfor %}


{% if grains['public'] %}
sshd.iptables:
  file.managed:
    - name: /etc/ferm.d/sshd.conf
    - source: salt://ssh/files/ferm.conf
    - makedirs: True
    - require_in:
      - file: ferm
{% endif %}
