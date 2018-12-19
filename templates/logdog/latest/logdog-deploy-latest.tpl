<@swarm.SERVICE 'logdog-${namespace}' 'imagenarium/logdog:latest-master' '' 'global'>
  <@service.NETWORK 'es-net-${namespace}' />
</@swarm.SERVICE>
