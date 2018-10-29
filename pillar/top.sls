base:
  '*':
    - common.*
    - hosts.*.public.*
    - hosts.{{ grains.id }}.private.*
  
  # 'hive':
  #   - match: nodegroup
  #   - groups.hive.*

  # 'frontend':
  #   - match: nodegroup
  #   - groups.frontend.*

  # 'router':
  #   - match: nodegroup
  #   - groups.router.*

  # '*':frontend
  #   #- sysctl
  #   #- network
  #   #- ssh
  #   - tinc
  #   #- opennms
  #   #- backup

  # 'router':
  #   #- forwardings
  #   #- dsl
  #   #- aiccu
  #   #- ddclient
  #   - peerings

  # '*-zitadelle':
  #   - web

  # '*-zitadelle or bunker':
  #   - match: compound
  #   - database
  #   - peerings

  # '*-zitadelle or bunker or brueckenkopf':
  #   - match: compound
  #   - letsencrypt

  # 'brueckenkopf':
  #   - irccat
  #   - hive

