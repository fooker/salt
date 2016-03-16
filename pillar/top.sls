base:
  '*':
    - sysctl
    - network
    - ssh
    - tinc
    - opennms
    - backup
    - cluster

  'router':
    - forwardings
    - dsl
    - aiccu
    - ddclient
    - locums

  '*-zitadelle':
    - wolke

  '*-zitadelle or bunker':
    - match: compound
    - database

  '*-zitadelle or bunker or brueckenkopf':
    - match: compound
    - letsencrypt

