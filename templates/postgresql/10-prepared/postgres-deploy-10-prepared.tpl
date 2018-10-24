<@requirement.CONS 'postgres' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />
<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />
<@requirement.PARAM name='POSTGRES_USER' value='smz' />
<@requirement.PARAM name='POSTGRES_PASSWORD' value='smz' />
<@requirement.PARAM name='POSTGRES_DB' value='postgres' />
<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='postgres-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-postgres-${namespace}' 'postgres-net-${namespace}' />

  <@swarm.SERVICE 'postgres-${namespace}' 'imagenarium/postgresql:10.4-data'>
    <@service.NETWORK 'postgres-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '5432' />
    <@service.VOLUME 'postgres-volume-${namespace}' '/var/lib/postgresql/data' />
    <@service.CONS 'node.labels.postgres' 'true' />
    <@service.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
    <@service.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
    <@service.ENV 'POSTGRES_DB' PARAMS.POSTGRES_DB />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-postgres-${namespace}' />
    <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
    <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
  </@swarm.SERVICE>

  <@docker.CONTAINER 'postgres-checker-${namespace}' 'imagenarium/postgresql:10.4-data'>
    <@container.NETWORK 'postgres-net-${namespace}' />
    <@container.ENV 'PGHOST' 'postgres-${namespace}' />
    <@container.ENV 'PGUSER' PARAMS.POSTGRES_USER />
    <@container.ENV 'PGPASSWORD' PARAMS.POSTGRES_PASSWORD />
    <@container.ENV 'PGDB' PARAMS.POSTGRES_DB />
    <@container.ENTRY '/checkdb.sh' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</@requirement.CONFORMS>