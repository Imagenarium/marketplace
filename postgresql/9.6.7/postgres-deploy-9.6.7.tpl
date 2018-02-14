<@requirement.CONS 'postgres' 'true' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='postgres-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-postgres-${namespace}' 'network-${namespace}' />

  <@swarm.TASK 'postgres-${namespace}' 'imagenarium/postgresql:9.6.7_1'>
    <@container.NETWORK 'postgres-net-${namespace}' />
    <@container.VOLUME 'postgres-volume-${namespace}' '/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-postgres-${namespace}' />
    <@container.ENV 'NEW_DB' PARAMS.DELETE_DATA />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'postgres-${namespace}'>
    <@service.CONS 'node.labels.postgres' 'true' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>