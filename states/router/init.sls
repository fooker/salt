router.iptables:
  file.managed:
    - name: /etc/ferm.d/sshd.conf
    - source: salt://ssh/ferm.conf
    - makedirs: True

