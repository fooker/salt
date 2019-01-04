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
                  name='strongswan')
    Service.running('peering.gre.ipsec',
                    name='strongswan',
                    enable=True,
                    require=[Pkg('peering.gre.ipsec'),
                             File('peering.gre.ipsec.conf'),
                             File('peering.gre.ipsec.secrets'),
                             File('peering.gre.strongswan.charon.conf')])

    File.managed('peering.gre.ipsec.conf',
                 name='/etc/ipsec.conf',
                 source='salt://peering/files/ipsec.conf.j2',
                 makedirs=True,
                 template='jinja')

    File.managed('peering.gre.ipsec.secrets',
                 name='/etc/ipsec.secrets',
                 source='salt://peering/files/ipsec.secrets.j2',
                 makedirs=True,
                 template='jinja')

    Kmod.present('peering.gre.iptables',
                 name='nf_conntrack_proto_gre',
                 persist=True)
    File.managed('peering.gre.iptables',
                 name='/etc/ferm.d/peering-gre.conf',
                 source='salt://peering/files/ferm.gre.conf.j2',
                 makedirs=True,
                 template='jinja',
                 require=Kmod('peering.gre.iptables'),
                 require_in=File('ferm'))

    File.managed('peering.gre.strongswan.charon.conf',
                 name='/etc/strongswan.d/charon.conf',
                 source='salt://peering/files/strongswan.charon.conf',
                 makedirs=True,
                 template='jinja')


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
                 source='salt://peering/files/wireguard@.service',
                 makedirs=True)

    File.managed('peering.wireguard.iptables',
                 name='/etc/ferm.d/peering-wireguard.conf',
                 source='salt://peering/files/ferm.wireguard.conf.j2',
                 makedirs=True,
                 template='jinja',
                 require_in=File('ferm'))


# Firewall for peerings
File.managed('peering.iptables',
             name='/etc/ferm.d/peering-peers.conf',
             source='salt://peering/files/ferm.peers.conf.j2',
             makedirs=True,
             template='jinja',
             require_in=File('ferm'))

# Domain dummy interfaces
for domain in pillar('peering:domains'):
    if domain in pillar('addresses:' + grains('id')):
        File.managed('peering.domain.' + domain + '.netdev',
                    name='/etc/systemd/network/90-peering-' + domain + '.netdev',
                    source='salt://peering/files/networkd.domain.netdev.j2',
                    makedirs=True,
                    template='jinja',
                    context={'domain': domain},
                    require_in=File('network'))

        File.managed('peering.domain.' + domain + '.network',
                    name='/etc/systemd/network/90-peering-' + domain + '.network',
                    source='salt://peering/files/networkd.domain.network.j2',
                    makedirs=True,
                    template='jinja',
                    context={'domain': domain},
                    require_in=File('network'))

# Per tunnel interface and configuration
for peer in pillar('peering:transfers:' + grains('id')):
    proto = pillar('peering:transfers:' + grains('id') + ':' + peer + ':proto')
    netdev = pillar('peering:peers:' + peer + ':netdev')

    if proto in ('gre', 'gre6'):
        File.managed('peering.tunnel.' + peer + '.gre.netdev',
                     name='/etc/systemd/network/80-peering-' + peer + '.netdev',
                     source='salt://peering/files/networkd.tunnel.' + proto + '.netdev.j2',
                     makedirs=True,
                     template='jinja',
                     context={'peer': peer},
                 require_in=File('network'))

        File.accumulated('peering.tunnel.' + peer + '.gre.netdev.hook',
                         name='tunnels',
                         filename='/etc/systemd/network/70-ext.network',
                         text='peer.' + netdev,
                         require_in=[File('network.ext.network'),
                                     File('network')])

        File.managed('peering.tunnel.' + peer + '.gre.ipsec.cert',
                     name='/etc/ipsec.d/certs/' + peer + '.pem',
                     content_pillar='peering:peers:' + peer + ':ipsec:pubkey',
                     makedirs=True)

    if proto == 'wireguard':
        File.managed('peering.tunnel.' + peer + '.wireguard',
                     name='/etc/wireguard/peer.' + netdev + '.conf',
                     source='salt://peering/files/wireguard.conf.j2',
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
                 source='salt://peering/files/networkd.tunnel.network.j2',
                 makedirs=True,
                 template='jinja',
                 context={'peer': peer},
                 require_in=File('network'))

# Kernel configuration
Sysctl.present('peering.sysctl.forwarding.ipv4',
               name='net.ipv4.conf.all.forwarding',
               value=1,
               config='/etc/sysctl.d/80-peering.conf')
Sysctl.present('peering.sysctl.forwarding.ipv6',
               name='net.ipv6.conf.all.forwarding',
               value=1,
               config='/etc/sysctl.d/80-peering.conf')

Sysctl.present('peering.sysctl.rp_filter.all',
                   name='net.ipv4.conf.all.rp_filter',
                   value=0,
                   config='/etc/sysctl.d/80-peering.conf')

for peer in pillar('peering:transfers:' + grains('id')):
    netdev = pillar('peering:peers:' + peer + ':netdev')

    Sysctl.present('peering.sysctl.rp_filter.' + netdev,
                   name='net.ipv4.conf.peer/' + netdev.replace('.', '/') + '.rp_filter',
                   value=0,
                   config='/etc/sysctl.d/80-peering.conf')

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
             source='salt://peering/files/bird.conf.j2',
             makedirs=True,
             template='jinja')

