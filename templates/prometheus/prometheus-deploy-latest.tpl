<@requirement.CONSTRAINT 'prometheus' 'true' />

<@requirement.PARAM name='PROMETHEUS_ADMIN_USER' value='admin' />
<@requirement.PARAM name='PROMETHEUS_ADMIN_PASSWORD' value='admin' />

<@requirement.PARAM name='ALERTDASHBOARD_PUBLISHED_PORT' required='false' type='port' />
<@requirement.PARAM name='PROMETHEUS_PUBLISHED_PORT'     required='false' type='port' />
<@requirement.PARAM name='ALERTMANAGER_PUBLISHED_PORT'   required='false' type='port' />

<@swarm.SERVICE 'alertmanager-${namespace}' 'imagenarium/alertmanager:0.16.1-debian'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.VOLUME '/alertmanager' />
  <@service.CONSTRAINT 'prometheus' 'true' />
  <@service.CHECK_PORT '9093' />
</@swarm.SERVICE>

<@swarm.SERVICE 'prometheus-${namespace}' 'imagenarium/prometheus:2.7.1-debian' '--storage.tsdb.retention.time=24h'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'prometheus' 'true' />
  <@service.VOLUME '/prometheus' />
  <@service.CHECK_PORT '9090' />
</@swarm.SERVICE>

<@swarm.SERVICE 'promconnect-${namespace}' 'fn61/promswarmconnect:20190126_1620_7b450c47'>
  <@node.MANAGER />
  <@service.NETWORK 'net-${namespace}' />
  <@service.ENV 'DOCKER_URL' 'unix:///var/run/docker.sock' />
  <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
  <@service.CHECK_PORT '443' />
</@swarm.SERVICE>

<@swarm.SERVICE 'caddy-${namespace}' 'imagenarium/caddy'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'prometheus' 'true' />
  <@service.PORT PARAMS.PROMETHEUS_PUBLISHED_PORT '9090' />
  <@service.PORT PARAMS.ALERTMANAGER_PUBLISHED_PORT '9093' />
  <@service.PORT PARAMS.ALERTDASHBOARD_PUBLISHED_PORT '9094' />
  <@service.ENV 'ADMIN_USER' PARAMS.PROMETHEUS_ADMIN_USER />
  <@service.ENV 'ADMIN_PASSWORD' PARAMS.PROMETHEUS_ADMIN_PASSWORD />
  <@service.CHECK_PORT '9090' />
</@swarm.SERVICE>
