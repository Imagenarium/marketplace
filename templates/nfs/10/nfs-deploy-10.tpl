<@requirement.CONSTRAINT 'nfs' 'true' />

<@requirement.PARAM name='NFS_PUBLISHED_PORT' type='port' required='false' description='Specify nfs external port (for example 2049)' />
          
<@img.TASK 'nfs-${namespace}' 'imagenarium/nfs:10'>
  <@img.VOLUME '/data' />
  <@img.NETWORK 'net-${namespace}' />
  <@img.CONSTRAINT 'nfs' 'true' />
  <@img.DNSRR />
  <@img.PORT PARAMS.NFS_PUBLISHED_PORT '2049' 'host' />
  <@img.CHECK_PORT '2049' />
</@img.TASK>
