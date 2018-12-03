<@swarm.SERVICE 'logdog-${namespace}' 'imagenarium/logdog:0.1' '' 'global'>
  <@service.NETWORK 'es-net-${namespace}' />
</@swarm.SERVICE>
