sysctl:
  # Disable IPv6 autoconfiguration
  net.ipv6.conf.default.accept_ra: 0
  net.ipv6.conf.all.accept_ra: 0

  # Enable IPv6 Privacy Extensions
  net.ipv6.conf.all.use_tempaddr: 2
  net.ipv6.conf.default.use_tempaddr: 2

  # Enable source route verification
  net.ipv4.conf.default.rp_filter: 1

  # Enable reverse path
  net.ipv4.conf.all.rp_filter: 1

  # Enable SYN cookies
  net.ipv4.tcp_syncookies: 1

  # Drop RST packets for sockets in the time-wait state
  net.ipv4.tcp_rfc1337: 1

  # Ignore ICMP broadcasts
  net.ipv4.icmp_echo_ignore_broadcasts: 1

  # Ignore bogus icmp errors
  net.ipv4.icmp_ignore_bogus_error_responses: 1

  # Do not accept ICMP redirects
  net.ipv4.conf.default.accept_redirects: 0
  net.ipv4.conf.all.accept_redirects: 0
  net.ipv6.conf.default.accept_redirects: 0
  net.ipv6.conf.all.accept_redirects: 0

  # Do not send ICMP redirects
  net.ipv4.conf.default.send_redirects: 0
  net.ipv4.conf.all.send_redirects: 0

  # Disable secure redirects
  net.ipv4.conf.default.secure_redirects: 0
  net.ipv4.conf.all.secure_redirects: 0

  # Do not accept IP source route packets
  net.ipv4.conf.default.accept_source_route: 0
  net.ipv4.conf.all.accept_source_route: 0
  net.ipv6.conf.default.accept_source_route: 0
  net.ipv6.conf.all.accept_source_route: 0

  # When the kernel panics, reboot in 3 seconds
  kernel.panic: 3

  # Disables the magic-sysrq key
  kernel.sysrq: 0

  # Adjust swappieness
  vm.swappiness: 20
  vm.dirty_ratio: 40
  vm.laptop_mode: 0
