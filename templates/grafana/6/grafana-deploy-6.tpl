<@requirement.CONSTRAINT 'grafana' 'true' />

<@requirement.PARAM name='GRAFANA_ADMIN_USER' value='admin' />
<@requirement.PARAM name='GRAFANA_ADMIN_PASSWORD' value='admin' />

<@requirement.PARAM name='GRAFANA_PUBLISHED_PORT' value='3000' type='port' />

<@swarm.SERVICE 'grafana-${namespace}' 'imagenarium/grafana-img:6.0.1'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.GRAFANA_PUBLISHED_PORT '3000' />
  <@service.VOLUME '/var/lib/grafana' />
  <@service.VOLUME '/var/log/grafana' />
  <@service.CONSTRAINT 'grafana' 'true' />
  <@service.ENV 'ES_URL' 'http://es-${namespace}:9200' />
  <@service.ENV 'GF_SECURITY_ADMIN_USER' PARAMS.GRAFANA_ADMIN_USER />
  <@service.ENV 'GF_SECURITY_ADMIN_PASSWORD' PARAMS.GRAFANA_ADMIN_PASSWORD />
  <@service.ENV 'GF_USERS_ALLOW_SIGN_UP' 'false' />
  <@service.CHECK_PORT '3000' />
</@swarm.SERVICE>
