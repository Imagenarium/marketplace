<@requirement.CONSTRAINT 'postgres' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />
<@requirement.PARAM name='PMM_PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='PMM_USER' value='admin' />
<@requirement.PARAM name='PMM_PASSWORD' value='admin' type='password' />

<@requirement.PARAM name='POSTGRES_USER' value='postgres' />
<@requirement.PARAM name='POSTGRES_PASSWORD' value='postgres' />
<@requirement.PARAM name='POSTGRES_DB' value='postgres' />

<@swarm.SERVICE 'pmm-${namespace}' 'imagenarium/pmm:latest'>
  <@service.NETWORK 'postgres-net-${namespace}' />
  <@service.PORT PARAMS.PMM_PUBLISHED_PORT '80' />
  <@service.CONSTRAINT 'postgres' 'true' />
  <@service.VOLUME '/opt/prometheus/data' />
  <@service.VOLUME '/opt/consul-data' />
  <@service.VOLUME '/var/lib/mysql' />
  <@service.VOLUME '/var/lib/grafana' />
  <@service.ENV 'SERVER_USER' PARAMS.PMM_USER />
  <@service.ENV 'SERVER_PASSWORD' PARAMS.PMM_PASSWORD />
  <@service.CHECK_PORT '80' />
</@swarm.SERVICE>

<@swarm.SERVICE 'postgres-${namespace}' 'imagenarium/postgresql:10.6'>
  <@service.NETWORK 'postgres-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5432' />
  <@service.VOLUME '/var/lib/postgresql/data' />
  <@service.CONSTRAINT 'postgres' 'true' />
  <@service.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
  <@service.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
  <@service.ENV 'POSTGRES_DB' PARAMS.POSTGRES_DB />
  <@service.ENV 'NETWORK_NAME' 'postgres-net-${namespace}' />
  <@service.ENV 'PMM_USER' PARAMS.PMM_USER />
  <@service.ENV 'PMM_PASSWORD' PARAMS.PMM_PASSWORD />
  <@service.CHECK_PORT '5432' />
</@swarm.SERVICE>
