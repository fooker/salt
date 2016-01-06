base:
  '*':
    - sysctl
    - network
    - ssh
    - tinc
    - private.tinc
    - opennms
    - private.opennms
    - backup
    - cluster

  'router':
    - forwardings
    - private.dsl
    - private.aiccu
    - private.ddclient
    - ddclient
    - locums

  '*-zitadelle or bunker':
    - match: compound
    - database
    - private.database
