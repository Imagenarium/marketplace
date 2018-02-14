<@requirement.CONS 'postgres' 'true' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />
<@requirement.PARAM name='CHECK_DB' value='postgres' />
<@requirement.PARAM name='CHECK_DB_USER' value='sylex' />
<@requirement.PARAM name='CHECK_DB_PASSWORD' value='sylex' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='postgres-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />
  <@swarm.STORAGE 'swarmstorage-postgres-${namespace}' 'postgres-net-${namespace}' />

  <@swarm.SERVICE 'postgres-${namespace}' 'imagenarium/postgresql:9.6.7_1'>
    <@service.NETWORK 'postgres-net-${namespace}' />
    <@service.VOLUME 'postgres-volume-${namespace}' '/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
    <@service.CONS 'node.labels.postgres' 'true' />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-postgres-${namespace}' />
    <@service.ENV 'NEW_DB' PARAMS.DELETE_DATA />
  </@swarm.SERVICE>

  <@docker.CONTAINER 'postgres-checker-${namespace}' 'imagenarium/postgresql:9.6.7_1'>
    <@container.NETWORK 'postgres-net-${namespace}' />
    <@container.ENV 'PGHOST' 'postgres-${namespace}' />
    <@container.ENV 'PGDB' PARAMS.CHECK_DB />
    <@container.ENV 'PGUSER' PARAMS.CHECK_DB_USER />
    <@container.ENV 'PGPASSWORD' PARAMS.CHECK_DB_PASSWORD />
    <@container.ENTRY '/checkdb.sh' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</@requirement.CONFORMS>