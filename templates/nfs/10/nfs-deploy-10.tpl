<@requirement.CONSTRAINT 'nfs' 'true' />

<@requirement.PARAM name='NFS_PORT' type='port' required='false' description='Specify nfs external port (for example 2049)' />
          
<@img.TASK 'nfs-${namespace}' 'imagenarium/nfs:10'>
  <@img.VOLUME '/data' />
  <@img.NETWORK 'nfs-net-${namespace}' />
  <@img.CONSTRAINT 'nfs' 'true' />
  <@img.PORT PARAMS.NFS_PORT '2049' />
  <@img.CHECK_PORT '2049' />
</@img.TASK>
