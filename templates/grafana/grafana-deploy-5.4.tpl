<@requirement.PARAM name='ADMIN_USER' value='admin' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='admin' />

<@requirement.PARAM name='GRAFANA_PUBLISHED_PORT' value='3000' type='port' />

<@requirement.CONSTRAINT 'monitoring' 'true' />

<@swarm.SERVICE 'grafana-${namespace}' 'imagenarium/grafana-es:5.4.3'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.GRAFANA_PUBLISHED_PORT '3000' />
  <@service.VOLUME '/var/lib/grafana' />
  <@service.VOLUME '/var/log/grafana' />
  <@service.CONSTRAINT 'monitoring' 'true' />
  <@service.ENV 'GF_SECURITY_ADMIN_USER' PARAMS.ADMIN_USER />
  <@service.ENV 'GF_SECURITY_ADMIN_PASSWORD' PARAMS.ADMIN_PASSWORD />
  <@service.ENV 'GF_USERS_ALLOW_SIGN_UP' 'false' />
  <@service.CHECK_PORT '3000' />
</@swarm.SERVICE>
