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

  'router':
    - forwardings
    - private.ddclient
    - private.dsl
    - ddclient
    - locums
