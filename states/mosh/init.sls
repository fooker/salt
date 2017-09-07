mosh:
  pkg.installed:
    - name: mosh

mosh.iptables:
  file.managed:
    - name: /etc/ferm.d/mosh.conf
    - source: salt://mosh/ferm.conf
    - makedirs: True
    - require_in:
      - file: ferm
