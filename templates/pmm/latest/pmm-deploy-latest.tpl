<@requirement.CONSTRAINT 'pmm' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='PMM_USER' value='admin' global='true' />
<@requirement.PARAM name='PMM_PASSWORD' value='admin' type='password' global='true' />

<@swarm.SERVICE 'pmm-${namespace}' 'imagenarium/pmm:latest'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '80' />
  <@service.CONSTRAINT 'pmm' 'true' />
  <@service.VOLUME '/opt/prometheus/data' />
  <@service.VOLUME '/opt/consul-data' />
  <@service.VOLUME '/var/lib/mysql' />
  <@service.VOLUME '/var/lib/grafana' />
  <@service.ENV 'SERVER_USER' PARAMS.PMM_USER />
  <@service.ENV 'SERVER_PASSWORD' PARAMS.PMM_PASSWORD />
  <@service.CHECK_PORT '80' />
</@swarm.SERVICE>
