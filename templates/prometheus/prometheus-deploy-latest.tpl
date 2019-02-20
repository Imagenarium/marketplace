<@requirement.PARAM name='ADMIN_USER' value='admin' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='admin' />

<@requirement.PARAM name='ALERTDASHBOARD_PUBLISHED_PORT' required='false' type='port' />
<@requirement.PARAM name='PROMETHEUS_PUBLISHED_PORT'     required='false' type='port' />
<@requirement.PARAM name='ALERTMANAGER_PUBLISHED_PORT'   required='false' type='port' />

<@requirement.CONSTRAINT 'prometheus' 'true' />

<@swarm.SERVICE 'alertmanager-${namespace}' 'imagenarium/alertmanager:0.16.1-debian'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.VOLUME '/alertmanager' />
  <@service.CONSTRAINT 'prometheus' 'true' />
</@swarm.SERVICE>

<@swarm.SERVICE 'prometheus-${namespace}' 'imagenarium/prometheus:2.7.1-debian' '--storage.tsdb.retention=24h'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'prometheus' 'true' />
  <@service.VOLUME '/prometheus' />
  <@service.CHECK_PORT '9090' />
</@swarm.SERVICE>

<@swarm.SERVICE 'caddy-${namespace}' 'imagenarium/caddy'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'prometheus' 'true' />
  <@service.PORT PARAMS.PROMETHEUS_PUBLISHED_PORT '9090' />
  <@service.PORT PARAMS.ALERTMANAGER_PUBLISHED_PORT '9093' />
  <@service.PORT PARAMS.ALERTDASHBOARD_PUBLISHED_PORT '9094' />
  <@service.ENV 'ADMIN_USER' PARAMS.ADMIN_USER />
  <@service.ENV 'ADMIN_PASSWORD' PARAMS.ADMIN_PASSWORD />
  <@service.CHECK_PORT '9090' />
</@swarm.SERVICE>
