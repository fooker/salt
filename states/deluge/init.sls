deluge:
  pkg.installed:
    - pkgs:
      - deluge
      - python2-mako
      - python2-service-identity

  service.running:
    - name: deluged
    - enable: True
    - require:
      - pkg: deluge

deluge.web:
  service.running:
    - name: deluge-web
    - enable: True
    - require:
      - pkg: deluge
    - watch:
      - service: deluge

# deluge.netns:
#   file.managed:
#     - name: /usr/local/lib/systemd/system/deluge.service.d
#     - content: |
#       [Unit]
#       JoinsNamespaceOf=mullvad.service
# 
#       [Service]
#       PrivateNetwork=yes
#    - require_in:
#      - file: systemd.system


