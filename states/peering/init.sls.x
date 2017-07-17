#!pydsl

pillar = __salt__['pillar.get']
grains = __salt__['grains.get']

# Get the set of all protos required by the host
protos = {
  peer['proto']
  for peer
  in pillar('peering:transfers:' + grains('id')).values()
}


# Install IPSEC for GRE
if 'gre' in protos or 'gre6' in protos:
  gre_ipsec = state('peering.gre.ipsec')
  gre_ipsec.pkg.installed(name='stronswan',
                          sources={
                            'stronswan': 'salt://peering/strongswan-5.5.2-1-x86_64.pkg.tar.xz'
                          })
  gre_ipsec.service.running(name='strongswan',
                            enable=True) \
                   .require(pkg='strongswan',
                            file=['peering.gre.ipsec.conf'
                                  'peering.gre.ipsec.secrets'])
  gre_ipsec_conf = state('peering.gre.ipsec.conf')
  gre_ipsec_conf.file.managed(name='/etc/ipsec.conf',
                              source='salt://peering/ipsec.conf.tmpl',
                              makedirs=True,
                              template='jinja')
  gre_ipsec_secrets = state('peering.gre.ipsec.secrets')
  gre_ipsec_secrets.file.managed(name='/etc/ipsec.secrets',
                                 source='salt://peering/ipsec.secrets.tmpl',
                                 makedirs=True,
                                 template='jinja')
  gre_iptables = state('peering.gre.iptables')
  gre_iptables.kmod.present(name='nf_conntrack_proto_gre',
                            persist=True)
  gre_iptables.file.managed(name='/etc/ferm.d/peering-gre.conf',
                            source='salt://peering/ferm.gre.conf.tmpl',
                            makedirs=True,
                            template='jinja') \
                   .require(kmod='peering.gre.iptables') \
                   .require_in(file='ferm')


# Install wireguard
if 'wireguard' in protos:
  wireguard = state('peering.wireguard')
  wireguard.pkg.installed(pkgs=['wireguard-dkms', 'wireguard-tools'])
  wireguard.file.managed(name='/etc/systemd/system/wireguard@.service',
                         source='salt://peering/wireguard@.service')

  wireguard_iptables = state('peering.gre.iptables')
  wireguard_iptables.file.managed(name='/etc/ferm.d/peering-wireguard.conf',
                                  source='salt://peering/ferm.wireguard.conf.tmpl',
                                  makedirs=True,
                                  template='jinja') \
                         .require_in(file='ferm')


# Firewall for peerings
iptables = state('peering.iptables')
iptables.file.managed(name='/etc/ferm.d/peering-peers.conf',
                      source='salt://peering/ferm.peers.conf.tmpl',
                      makedirs=True,
                      template='jinja') \
             .require_in(file='ferm')

#{% for domain in pillar.peering.interfaces[grains.id] %}
#peering.domain.{{ domain }}.netdev:
#  file.managed:
#    - name: /etc/systemd/network/90-peering-{{ domain }}.netdev
#    - source: salt://peering/networkd.domain.netdev.tmpl
#    - makedirs: True
#    - template: jinja
#    - context:
#        domain: {{ domain }}
#
#peering.domain.{{ domain }}.network:
#  file.managed:
#    - name: /etc/systemd/network/90-peering-{{ domain }}.network
#    - source: salt://peering/networkd.domain.network.tmpl
#    - makedirs: True
#    - template: jinja
#    - context:
#        domain: {{ domain }}
#{% endfor %}
#
#{% for peer in pillar.peering.transfers[grains.id] %}
#{% if pillar.peering.transfers[grains.id][peer].proto in ('gre', 'gre6') %}
#peering.tunnel.{{ peer }}.netdev:
#  file.managed:
#    - name: /etc/systemd/network/80-peering-{{ peer }}.netdev
#    - source: salt://peering/networkd.tunnel.{{ pillar.peering.transfers[grains.id][peer].proto }}.netdev.tmpl
#    - makedirs: True
#    - template: jinja
#    - context:
#        peer: {{ peer }}
#{% endif %}
#{# if pillar.peering.transfers[grains.id][peer].proto == 'wireguard' %}
#peering.tunnel.{{ peer }}.service:
#  file.managed:
#    - name: /etc/systemd/system/wireguard@{{ peer }}.service
#    - source: salt://peering/networkd.tunnel.{{ pillar.peering.transfers[grains.id][peer].proto }}.netdev.tmpl
#    - makedirs: True
#    - template: jinja
#    - context:
#        peer: {{ peer }}
#{% endif #}
#
#peering.tunnel.{{ peer }}.network:
#  file.managed:
#    - name: /etc/systemd/network/80-peering-{{ peer }}.network
#    - source: salt://peering/networkd.tunnel.network.tmpl
#    - makedirs: True
#    - template: jinja
#    - context:
#        peer: {{ peer }}
#
#peering.tunnel.{{ peer }}.hook:
#  file.accumulated:
#    - name: tunnels
#    - filename: /etc/systemd/network/70-ext.network
#    - text: peer.{{ pillar.peering.peers[peer].netdev }}
#    - require_in:
#      - file: network.ext.network
#
#{% if  pillar.peering.transfers[grains.id][peer].proto in ('gre', 'gre6') %}
#peering.ipsec.certs.{{ pillar.peering.peers[peer].netdev }}:
#  file.managed:
#    - name: /etc/ipsec.d/certs/{{ pillar.peering.peers[peer].netdev }}.pem
#    - contents_pillar: peering:peers:{{ peer }}:ipsec:pubkey
#    - makedirs: True
#{% endif %}
#{% endfor %}
#
#peering.sysctl.forwarding.ipv4:
#  sysctl.present:
#    - name: net.ipv4.conf.all.forwarding
#    - value: 1
#    - config: /etc/sysctl.d/peering.conf
#
#peering.sysctl.forwarding.ipv6:
#  sysctl.present:
#    - name: net.ipv6.conf.all.forwarding
#    - value: 1
#    - config: /etc/sysctl.d/peering.conf
#
#peering.sysctl.rp_filter:
#  sysctl.present:
#    - name: net.ipv4.conf.all.rp_filter
#    - value: 0
#    - config: /etc/sysctl.d/peering.conf
#
#peering.bird:
#  pkg.installed:
#    - name: bird
#  service.running:
#    - name: bird
#    - enable: True
#    - reload: True
#    - require:
#      - pkg: peering.bird
#    - watch:
#      - file: /etc/bird.conf
#  file.managed:
#    - name: /etc/bird.conf
#    - source: salt://peering/bird.conf.tmpl
#    - makedirs: True
#    - template: jinja
#
#peering.bird6:
#  pkg.installed:
#    - name: bird6
#  service.running:
#    - name: bird6
#    - enable: True
#    - reload: True
#    - require:
#      - pkg: peering.bird6
#    - watch:
#      - file: /etc/bird6.conf
#  file.managed:
#    - name: /etc/bird6.conf
#    - source: salt://peering/bird6.conf.tmpl
#    - makedirs: True
#    - template: jinja
#
