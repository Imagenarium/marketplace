<@requirement.CONS 'nfs' 'true' />

<@requirement.PARAM name='NFS_PORT' value='2049' type='port' scope='global' />

<@requirement.PARAM name='NETWORK_DRIVER' type='network_driver' scope='global' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' scope='global' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' scope='global' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='3' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='nfs-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />  

  <@swarm.STORAGE 'swarmstorage-nfs-${namespace}' 'nfs-net-${namespace}' />

  <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
    <@swarm.VOLUME_RM 'nfs-volume-${namespace}' />
  </#if>
          
  <@swarm.TASK 'nfs-${namespace}'>
    <@container.NETWORK 'nfs-net-${namespace}' />
    <@container.VOLUME 'nfs-volume-${namespace}' '/data' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, PARAMS.VOLUME_SIZE_GB) />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-nfs-${namespace}' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'nfs-${namespace}' 'imagenarium/nfs:7'>
    <@service.NETWORK 'nfs-net-${namespace}' />
    <@service.CONS 'node.labels.nfs' 'true' />
    <@service.ENV 'PROXY_PORTS' '2049' />
    <@service.PORT PARAMS.NFS_PORT '2049' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>