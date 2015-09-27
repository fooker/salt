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
    - private.dsl
    - private.aiccu
    - private.ddclient
    - ddclient
    - locums
