<@requirement.HA />

<@requirement.CONS_HA 'glusterfs' 'true' />

<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='glusterfs-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />  
    
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign peers += ['glusterfs-${index}-${namespace}.1'] />
    <#assign volumes += ['glusterfs-${index}-${namespace}.1:/gluster-data'] />
  </@cloud.DATACENTER>
  
  <@swarm.STORAGE 'swarmstorage-glusterfs-${namespace}' 'glusterfs-net-${namespace}' />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
      <@swarm.VOLUME_RM 'glusterfs-data-volume-${index}-${namespace}' />
      <@swarm.VOLUME_RM 'glusterfs-lib-volume-${index}-${namespace}' />
    </#if>

    <@swarm.TASK 'glusterfs-${index}-${namespace}'>
      <@container.NETWORK 'glusterfs-net-${namespace}' />
      <@container.VOLUME 'glusterfs-data-volume-${index}-${namespace}' '/gluster-data' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
      <@container.VOLUME 'glusterfs-log-volume-${index}-${namespace}' '/var/log/glusterfs' />
      <@container.VOLUME 'glusterfs-lib-volume-${index}-${namespace}' '/var/lib/glusterd' PARAMS.VOLUME_DRIVER 'volume-opt=size=1gb' />
      <#if index == 3>
      <@container.ENV 'BUILD_NODE' 'true' />
      </#if>
      <@container.ENV 'PEERS' peers?join(" ") />
      <@container.ENV 'VOLUME_DRIVER' PARAMS.VOLUME_DRIVER />
      <@container.ENV 'VOLUMES' volumes?join(" ") />
      <@container.ENV 'VOLUMES_COUNT' volumes?size />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-glusterfs-${namespace}' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'glusterfs-${index}-${namespace}' 'imagenarium/glusterfs:3.13u27'>
      <@service.DC dc />
      <@service.CONS 'node.labels.glusterfs' 'true' />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>

  <@docker.HTTP_CHECKER 'gluster-checker-${namespace}' 'http://glusterfs-dc3-${namespace}.1:9200?action=check' 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>