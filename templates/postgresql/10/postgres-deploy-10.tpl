<@requirement.CONS 'postgres' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' scope='global' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' scope='global' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='8' type='number' />
<@requirement.PARAM name='POSTGRES_USER' value='postgres' />
<@requirement.PARAM name='POSTGRES_PASSWORD' value='postgres' />
<@requirement.PARAM name='POSTGRES_DB' value='postgres' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='postgres-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-postgres-${namespace}' 'postgres-net-${namespace}' />

  <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
    <@swarm.VOLUME_RM 'postgres-volume-${namespace}' />
  </#if>

  <@swarm.SERVICE 'postgres-${namespace}' 'imagenarium/postgresql:10.4'>
    <@service.NETWORK 'postgres-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '5432' />
    <@service.VOLUME 'postgres-volume-${namespace}' '/var/lib/postgresql/data' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, PARAMS.VOLUME_SIZE_GB) />
    <@service.CONS 'node.labels.postgres' 'true' />
    <@service.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
    <@service.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
    <@service.ENV 'POSTGRES_DB' PARAMS.POSTGRES_DB />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-postgres-${namespace}' />
    <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
  </@swarm.SERVICE>

  <@docker.CONTAINER 'postgres-checker-${namespace}' 'imagenarium/postgresql:10.4'>
    <@container.NETWORK 'postgres-net-${namespace}' />
    <@container.ENV 'PGHOST' 'postgres-${namespace}' />
    <@container.ENV 'PGUSER' PARAMS.POSTGRES_USER />
    <@container.ENV 'PGPASSWORD' PARAMS.POSTGRES_PASSWORD />
    <@container.ENV 'PGDB' PARAMS.POSTGRES_DB />
    <@container.ENTRY '/checkdb.sh' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</@requirement.CONFORMS>