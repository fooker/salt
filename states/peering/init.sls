#!pyobjects

# Get the set of all protos required by the host
protos = {
  peer['proto']
  for peer
  in pillar('peering:transfers:' + grains('id')).values()
}


# Install IPSEC for GRE
if 'gre' in protos or 'gre6' in protos:
    Pkg.installed('peering.gre.ipsec',
                  name='strongswan',
                  sources=[{'strongswan': 'salt://peering/strongswan-5.5.2-1-x86_64.pkg.tar.xz'}])
    Service.running('peering.gre.ipsec',
                    name='strongswan',
                    enable=True,
                    require=[Pkg('peering.gre.ipsec'),
                             File('peering.gre.ipsec.conf'),
                             File('peering.gre.ipsec.secrets')])

    File.managed('peering.gre.ipsec.conf',
                 name='/etc/ipsec.conf',
                 source='salt://peering/ipsec.conf.tmpl',
                 makedirs=True,
                 template='jinja')

    File.managed('peering.gre.ipsec.secrets',
                 name='/etc/ipsec.secrets',
                 source='salt://peering/ipsec.secrets.tmpl',
                 makedirs=True,
                 template='jinja')

    Kmod.present('peering.gre.iptables',
                 name='nf_conntrack_proto_gre',
                 persist=True)
    File.managed('peering.gre.iptables',
                 name='/etc/ferm.d/peering-gre.conf',
                 source='salt://peering/ferm.gre.conf.tmpl',
                 makedirs=True,
                 template='jinja',
                 require=Kmod('peering.gre.iptables'),
                 require_in=File('ferm'))


# Install wireguard
if 'wireguard' in protos:
    Pkg.installed('peering.wireguard',
                  pkgs=['linux-headers', 'wireguard-dkms', 'wireguard-tools'])
    File.directory('peering.wireguard',
                   name='/etc/wireguard',
                   makedirs=True,
                   clean=True)

    File.managed('peering.wireguard.service',
                 name='/etc/systemd/system/wireguard@.service',
                 source='salt://peering/wireguard@.service',
                 makedirs=True)

    File.managed('peering.wireguard.iptables',
                 name='/etc/ferm.d/peering-wireguard.conf',
                 source='salt://peering/ferm.wireguard.conf.tmpl',
                 makedirs=True,
                 template='jinja',
                 require_in=File('ferm'))


# Firewall for peerings
File.managed('peering.iptables',
             name='/etc/ferm.d/peering-peers.conf',
             source='salt://peering/ferm.peers.conf.tmpl',
             makedirs=True,
             template='jinja',
             require_in=File('ferm'))

# Domain dummy interfaces
for domain in pillar('peering:interfaces:' + grains('id')):
    File.managed('peering.domain.' + domain + '.netdev',
                 name='/etc/systemd/network/90-peering-' + domain + '.netdev',
                 source='salt://peering/networkd.domain.netdev.tmpl',
                 makedirs=True,
                 template='jinja',
                 context={'domain': domain})

    File.managed('peering.domain.' + domain + '.network',
                 name='/etc/systemd/network/90-peering-' + domain + '.network',
                 source='salt://peering/networkd.domain.network.tmpl',
                 makedirs=True,
                 template='jinja',
                 context={'domain': domain})

# Per tunnel interface and configuration
for peer in pillar('peering:transfers:' + grains('id')):
    proto = pillar('peering:transfers:' + grains('id') + ':' + peer + ':proto')
    netdev = pillar('peering:peers:' + peer + ':netdev')

    if proto in ('gre', 'gre6'):
        File.managed('peering.tunnel.' + peer + '.gre.netdev',
                     name='/etc/systemd/network/80-peering-' + peer + '.netdev',
                     source='salt://peering/networkd.tunnel.' + proto + '.netdev.tmpl',
                     makedirs=True,
                     template='jinja',
                     context={'peer': peer})

        File.accumulated('peering.tunnel.' + peer + '.gre.netdev.hook',
                         name='tunnels',
                         filename='/etc/systemd/network/70-ext.network',
                         text='peer.' + netdev,
                         require_in=File('network.ext.network'))

        File.managed('peering.tunnel.' + peer + '.gre.ipsec.cert',
                     name='/etc/ipsec.d/certs/' + peer + '.pem',
                     content_pillar='peering:peers:' + peer + ':ipsec:pubkey',
                     makedirs=True)

    if proto == 'wireguard':
        File.managed('peering.tunnel.' + peer + '.wireguard',
                     name='/etc/wireguard/peer.' + netdev + '.conf',
                     source='salt://peering/wireguard.conf.tmpl',
                     makedirs=True,
                     template='jinja',
                     mode=600,
                     context={'peer': peer},
                     require_in=File('peering.wireguard'))
        Service.running('peering.tunnel.' + peer + '.wireguard',
                        name='wireguard@peer.' + netdev,
                        enable=True,
                        reload=True,
                        require=Pkg('peering.wireguard'),
                        watch=[File('peering.tunnel.' + peer + '.wireguard'),
                               File('peering.wireguard.service')])

    File.managed('peering.tunnel.' + peer + '.network',
                 name='/etc/systemd/network/80-peering-' + peer + '.network',
                 source='salt://peering/networkd.tunnel.network.tmpl',
                 makedirs=True,
                 template='jinja',
                 context={'peer': peer})

# Kernel configuration
Sysctl.present('peering.sysctl.forwarding.ipv4',
               name='net.ipv4.conf.all.forwarding',
               value=1,
               config='/etc/sysctl.d/peering.conf')
Sysctl.present('peering.sysctl.forwarding.ipv6',
               name='net.ipv6.conf.all.forwarding',
               value=1,
               config='/etc/sysctl.d/peering.conf')
Sysctl.present('peering.sysctl.rp_filter',
               name='net.ipv4.conf.all.rp_filter',
               value=1,
               config='/etc/sysctl.d/peering.conf')

# BIRD config
Pkg.installed('peering.bird',
              name='bird')
Service.running('peering.bird',
                name='bird',
                enable=True,
                reload=True,
                require=Pkg('peering.bird'),
                watch=File('peering.bird'))
File.managed('peering.bird',
             name='/etc/bird.conf',
             source='salt://peering/bird.conf.tmpl',
             makedirs=True,
             template='jinja')

Pkg.installed('peering.bird6',
              name='bird6')
Service.running('peering.bird6',
                name='bird6',
                enable=True,
                reload=True,
                require=Pkg('peering.bird6'),
                watch=File('peering.bird6'))
File.managed('peering.bird6',
             name='/etc/bird6.conf',
             source='salt://peering/bird6.conf.tmpl',
             makedirs=True,
             template='jinja')

