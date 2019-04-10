<@swarm.SERVICE 'swarmview-${namespace}' 'imagenarium/swarmview:2.1.0.RC1' '' 'global'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.ENV 'ENABLE_EVENTS' 'true' />
  <@service.ENV 'ENABLE_CONTAINERS' 'true' />
  <@service.ENV 'ENABLE_HOSTS' 'true' />
  <@service.ENV 'ENABLE_VOLUMES' 'true' />
  <@service.ENV 'ENABLE_SWARM' 'true' />
</@swarm.SERVICE>
