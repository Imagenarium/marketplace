<@requirement.CONSTRAINT 'nfs' 'true' />

<@requirement.PARAM name='NFS_PORT' type='port' required='false' description='Specify nfs external port (for example 2049)' />
          
<@swarm.TASK 'nfs-${namespace}'>
  <@container.VOLUME '/data' />
</@swarm.TASK>

<@swarm.TASK_RUNNER 'nfs-${namespace}' 'imagenarium/nfs:10'>
  <@service.NETWORK 'nfs-net-${namespace}' />
  <@service.CONSTRAINT 'nfs' 'true' />
  <@service.PORT PARAMS.NFS_PORT '2049' />
  <@service.CHECK_PORT '2049' />
</@swarm.TASK_RUNNER>
