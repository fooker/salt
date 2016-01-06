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

  '*-zitadelle or bunker':
    - match: compound
    - database
