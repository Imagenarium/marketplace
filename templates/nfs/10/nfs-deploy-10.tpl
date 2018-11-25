<@requirement.CONSTRAINT 'nfs' 'true' />

<@requirement.PARAM name='NFS_PORT' type='port' required='false' description='Specify nfs external port (for example 2049)' />
          
<@swarm.TASK 'nfs-${namespace}'>
  <@container.NETWORK 'nfs-net-${namespace}' />
  <@container.VOLUME '/data' />
</@swarm.TASK>

<@swarm.TASK_RUNNER 'nfs-${namespace}' 'imagenarium/nfs:10'>
  <@service.CONSTRAINT 'nfs' 'true' />
  <@service.ENV 'PROXY_PORTS' '2049' />
  <@service.PORT PARAMS.NFS_PORT '2049' />
</@swarm.TASK_RUNNER>
