dnsmasq:
  pkg.installed:
    - name: dnsmasq
  service.running:
    - enable: True
    - name: dnsmasq
    - require:
      - pkg: dnsmasq
    - watch:
      - file: /etc/dnsmasq.conf
      - file: /etc/dnsmasq.hosts
      - file: /etc/dnsmasq.conf.d/*

dnsmasq.conf:
  file.managed:
    - name: /etc/dnsmasq.conf
    - source: salt://router/dnsmasq/files/dnsmasq.conf
    - makedirs: True

dnsmasq.conf.d:
  file.directory:
    - name: /etc/dnsmasq.conf.d
    - makedirs: True
