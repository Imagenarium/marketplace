<@swarm.SERVICE 'coredns-${namespace}' 'imagenarium/coredns:1.4' '' 'global'>
  <@service.NETWORK 'net-${namespace}' />
</@swarm.SERVICE>
