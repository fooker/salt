base:
  '*':
    - sysctl
    - network
    - ssh
    - tinc
    - opennms
    - backup

  'router':
    - forwardings
    - dsl
    - aiccu
    - ddclient
    - locums

  '*-zitadelle':
    - web

  '*-zitadelle or bunker':
    - match: compound
    - database
    - hive

  '*-zitadelle or bunker or brueckenkopf':
    - match: compound
    - letsencrypt

