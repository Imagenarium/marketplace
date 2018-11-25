<@requirement.CONS 'nfs' 'true' />

<@requirement.PARAM name='NFS_PORT' type='port' required='fase' description='Specify nfs external port (for example 2049)' />
<@requirement.PARAM name='NETWORK_DRIVER' type='network_driver' scope='global' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' scope='global' />
<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='nfs-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />  

  <@swarm.STORAGE 'swarmstorage-nfs-${namespace}' 'nfs-net-${namespace}' />
          
  <@swarm.TASK 'nfs-${namespace}'>
    <@container.NETWORK 'nfs-net-${namespace}' />
    <@container.VOLUME 'nfs-volume-${namespace}' '/data' />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-nfs-${namespace}' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'nfs-${namespace}' 'imagenarium/nfs:7'>
    <@service.CONS 'node.labels.nfs' 'true' />
    <@service.ENV 'PROXY_PORTS' '2049' />
    <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
    <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
    <@service.PORT PARAMS.NFS_PORT '2049' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>