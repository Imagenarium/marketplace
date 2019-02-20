<@requirement.PARAM name='PROMETHEUS_PUBLISHED_PORT' required='false' type='port' />

<@requirement.CONSTRAINT 'prometheus' 'true' />

<@swarm.SERVICE 'prometheus-${namespace}' 'imagenarium/bb:latest'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'prometheus' 'true' />
  <@service.VOLUME '/prometheus' />
  <@service.PORT PARAMS.PROMETHEUS_PUBLISHED_PORT '9090' />
  <@service.CHECK_PORT '9090' />
</@swarm.SERVICE>
