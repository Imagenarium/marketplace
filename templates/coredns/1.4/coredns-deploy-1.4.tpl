<@swarm.SERVICE 'coredns-${namespace}' 'imagenarium/coredns:1.4' '' 'global'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT '53' '53' 'host' 'udp' />
</@swarm.SERVICE>
