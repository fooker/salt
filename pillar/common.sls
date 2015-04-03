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


sshd:
  authorized_keys:
    fooker: AAAAB3NzaC1yc2EAAAADAQABAAABAQCcCealTEGSthVbKvtVlRgWdl+YkEuKfn2O43YhwTFcLX4YXXlADbv3slbtDkJcesKMAM4QXqjzTIW2UQU9Ry7TYDlo2RhT4xyObuwYNHW15Jg/VqyCB5MbBo/AJGF1x9VKRHg4l5BNiCuWF7caInJK0LoxhvJ1Zt9Bs36b0V9ZQOxnKmj0yt3iEIr4qUf0wAPUh2FgbHBi+Z+0LjwA1TSXMoDCV2Uupd4qk8pOEiPHDnzlItZf89LEouRRjLw36lCeIRDGXN+n83lv+oKI0eNJomqe1KxGOu5rlYJKxdKkCO30Dab1I2tMsvOZf7ehfvM3S7KGDTh036m5alF3iI4L
    rsnapshot: AAAAB3NzaC1yc2EAAAADAQABAAABAQCeON9hC8pDqDSk86l2wpDSzNGYKvUoXljScDuu348VhAf+SIFoHYAmWwxxFPcurad9xezfXV5isFXdQb0tMnMFvMb1WOQkJeIG2yCj3xbRJc4Wv4iE8I7cgJwWbwgXD4lmODeXkDSIKLqqasrzed+R2Pnl4FlVStrdRGywHL0TxOBdZOOvAxkK4JP+6EOBE1XHQBaaqx9ifrnFXG4K5iiH4wzC1ACJSEgXPNa2txzXL2pPEDn86/WcHFjcWSPyTGw1KEQx90BKlofq94cCjTUdz5FcCX2V2TH4uZQmHb2tOUnJefaWodQt1C+qjwivPl+PccNI0dQ1H7kT4wobtzSx

