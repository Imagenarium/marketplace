<@requirement.PARAM name='PUBLISHED_PROXY_PORT' type='port' required='false' />
<@requirement.PARAM name='PUBLISHED_ADMIN_PORT' type='port' required='false' />

<@swarm.SERVICE 'logdog-${namespace}' 'imagenarium/logdog:0.1' '' 'global'>
  <@service.NETWORK 'es-net-${namespace}' />
</@swarm.SERVICE>
