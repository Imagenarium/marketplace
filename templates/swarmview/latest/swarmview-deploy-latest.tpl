<@swarm.SERVICE 'swarmview-${namespace}' 'imagenarium/swarmview:latest-master' '' 'global'>
  <@service.NETWORK 'es-net-${namespace}' />
</@swarm.SERVICE>
