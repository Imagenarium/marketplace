<@requirement.CONS 'nfs' 'true' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='FILESTORAGE_VOLUME_SIZE_GB' value='1' type='number' />
<@requirement.PARAM name='TEMP_VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='nfs-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />  

  <@swarm.STORAGE 'swarmstorage-nfs-${namespace}' 'nfs-net-${namespace}' />
          
  <@swarm.TASK 'nfs-filestorage-${namespace}'>
    <@container.NETWORK 'nfs-net-${namespace}' />
    <@container.VOLUME 'nfs-filestorage-${namespace}' '/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.FILESTORAGE_VOLUME_SIZE_GB}gb' />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'SHARED_DIRECTORY' '/data' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-nfs-${namespace}' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'nfs-filestorage-${namespace}' 'imagenarium/nfs:7'>
    <@service.CONS 'node.labels.nfs' 'true' />
  </@swarm.TASK_RUNNER>

  <@swarm.TASK 'nfs-temp-${namespace}'>
    <@container.NETWORK 'nfs-net-${namespace}' />
    <@container.VOLUME 'nfs-temp-${namespace}' '/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.TEMP_VOLUME_SIZE_GB}gb' />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'SHARED_DIRECTORY' '/data' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-nfs-${namespace}' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'nfs-temp-${namespace}' 'imagenarium/nfs:7'>
    <@service.CONS 'node.labels.nfs' 'true' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>