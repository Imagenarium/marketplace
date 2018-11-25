<@requirement.CONSTRAINT 'postgres' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />

<@requirement.PARAM name='POSTGRES_USER' value='postgres' />
<@requirement.PARAM name='POSTGRES_PASSWORD' value='postgres' />
<@requirement.PARAM name='POSTGRES_DB' value='postgres' />

<@swarm.SERVICE 'postgres-${namespace}' 'imagenarium/postgresql:11.1'>
  <@service.NETWORK 'postgres-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5432' />
  <@service.VOLUME '/var/lib/postgresql/data' />
  <@service.CONSTRAINT 'postgres' 'true' />
  <@service.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
  <@service.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
  <@service.ENV 'POSTGRES_DB' PARAMS.POSTGRES_DB />
</@swarm.SERVICE>

<@docker.CONTAINER 'postgres-checker-${namespace}' 'imagenarium/postgresql:11.1'>
  <@container.NETWORK 'postgres-net-${namespace}' />
  <@container.ENV 'PGHOST' 'postgres-${namespace}' />
  <@container.ENV 'PGUSER' PARAMS.POSTGRES_USER />
  <@container.ENV 'PGPASSWORD' PARAMS.POSTGRES_PASSWORD />
  <@container.ENV 'PGDB' PARAMS.POSTGRES_DB />
  <@container.ENTRY '/checkdb.sh' />
  <@container.EPHEMERAL />
</@docker.CONTAINER>
