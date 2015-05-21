vnstat:
  pkg:
    - installed
    - name: vnstat
  service:
    - running
    - enable: True
    - name: vnstat
    - require:
      - pkg: vnstat
