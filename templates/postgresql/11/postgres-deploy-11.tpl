<@requirement.CONSTRAINT 'postgres' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />

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
</@swarm.SERVICE>

<@docker.HTTP_CHECKER 'pmm-checker-${namespace}' 'http://pmm-${namespace}:80/graph' 'postgres-net-${namespace}' />

<@swarm.SERVICE 'postgres-${namespace}' 'imagenarium/postgresql:11.1'>
  <@service.NETWORK 'postgres-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5432' />
  <@service.VOLUME '/var/lib/postgresql/data' />
  <@service.CONSTRAINT 'postgres' 'true' />
  <@service.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
  <@service.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
  <@service.ENV 'POSTGRES_DB' PARAMS.POSTGRES_DB />
  <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
</@swarm.SERVICE>

<@docker.TCP_CHECKER 'postgres-checker-${namespace}' 'postgres-${namespace}:5432' 'postgres-net-${namespace}' />
