<@requirement.PARAM name='ADMIN_USER' value='admin' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='admin' />

<@requirement.PARAM name='ALERTDASHBOARD_PUBLISHED_PORT' required='false' type='port' />
<@requirement.PARAM name='PROMETHEUS_PUBLISHED_PORT'     required='false' type='port' />
<@requirement.PARAM name='ALERTMANAGER_PUBLISHED_PORT'   required='false' type='port' />

<@requirement.CONSTRAINT 'prometheus' 'true' />

<@swarm.SERVICE 'alertmanager-${namespace}' 'prom/alertmanager:v0.15.3'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'prometheus' 'true' />
</@swarm.SERVICE>

<@swarm.SERVICE 'prometheus-${namespace}' 'imagenarium/prometheus-kafka:v2.5.0' '--storage.tsdb.retention=24h'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'prometheus' 'true' />
  <@node.MANAGER />
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
  <@service.CHECK_PATH ':3000/login' />
</@swarm.SERVICE>
