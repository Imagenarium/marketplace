<@requirement.CONS 'nfs' 'true' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' values='weave:latest,overlay' type='select' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' values='vmware,do,aws,gce,azure,local' type='select' />
<@requirement.PARAM name='VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='READ_ONLY' value='false' type='boolean' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='nfs-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />  

  <@swarm.SERVICE 'swarmstorage-nfs-${namespace}' 'imagenarium/swarmstorage:0.5.0'>
    <@service.NETWORK 'nfs-net-${namespace}' />
    <@node.MANAGER />
  </@swarm.SERVICE>
          
  <@swarm.TASK 'nfs-filestorage-${namespace}'>
    <@container.NETWORK 'nfs-net-${namespace}' />
    <@container.VOLUME 'nfs-filestorage-${namespace}' '/data' PARAMS.VOLUME_DRIVER PARAMS.VOLUME_OPTS?trim />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'SHARED_DIRECTORY' '/data' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-nfs-${namespace}' />
    <@container.ENV 'READ_ONLY' PARAMS.READ_ONLY />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'nfs-filestorage-${namespace}' 'imagenarium/nfs:7'>
    <@service.CONS 'node.labels.nfs' 'true' />
  </@swarm.TASK_RUNNER>

  <@swarm.TASK 'nfs-temp-${namespace}'>
    <@container.NETWORK 'nfs-net-${namespace}' />
    <@container.VOLUME 'nfs-temp-${namespace}' '/data' PARAMS.VOLUME_DRIVER PARAMS.VOLUME_OPTS?trim />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'SHARED_DIRECTORY' '/data' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-nfs-${namespace}' />
    <@container.ENV 'READ_ONLY' PARAMS.READ_ONLY />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'nfs-temp-${namespace}' 'imagenarium/nfs:7'>
    <@service.CONS 'node.labels.nfs' 'true' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>