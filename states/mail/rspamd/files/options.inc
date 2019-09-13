### This file is managed by saltstack - any changes will be overwritten ###

local_addrs = "127.0.0.0/8, ::1";

dns {
  nameserver = ["[::1]:15353"];
}

neighbours {
    server1 { host = "https://spam.mx1.open-desk.net:443"; }
    server2 { host = "https://spam.mx2.open-desk.net:443"; }
}
