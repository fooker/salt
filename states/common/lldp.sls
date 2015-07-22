lldpd:
  pkg:
    - installed
    - name: lldpd
  service:
    - running
    - name: lldpd
    - enable: True
    - require:
      - pkg: lldpd

