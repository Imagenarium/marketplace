<@requirement.CONSTRAINT 'postgres' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />
<@requirement.PARAM name='PMM_PUBLISHED_PORT' type='port' required='false' />

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
  <@service.CHECK_PATH ':80/graph' />
</@swarm.SERVICE>

<@swarm.SERVICE 'postgres-${namespace}' 'imagenarium/postgresql:11.1'>
  <@service.NETWORK 'postgres-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5432' />
  <@service.VOLUME '/var/lib/postgresql/data' />
  <@service.CONSTRAINT 'postgres' 'true' />
  <@service.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
  <@service.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
  <@service.ENV 'POSTGRES_DB' PARAMS.POSTGRES_DB />
  <@service.ENV 'NETWORK_NAME' 'postgres-net-${namespace}' />
  <@service.CHECK_PORT '5432' />
</@swarm.SERVICE>
