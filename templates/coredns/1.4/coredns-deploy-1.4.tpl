<@swarm.SERVICE 'coredns-${namespace}' 'imagenarium/coredns:1.4' '' 'global'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT '53' '53' 'host' 'udp' />
</@swarm.SERVICE>

<@swarm.SERVICE 'dns-agent-${namespace}' 'imagenarium/dns:2.1.0.RC1' '' 'global'>
  <@service.NETWORK 'net-${namespace}' />
</@swarm.SERVICE>
