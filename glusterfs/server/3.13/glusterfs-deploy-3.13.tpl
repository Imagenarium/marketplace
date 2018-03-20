<@requirement.CONS 'glusterfs' '1' />
<@requirement.CONS 'glusterfs' '2' />
<@requirement.CONS 'glusterfs' '3' />

<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='glusterfs-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />  
    
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <#list "1,2,3"?split(",") as index>
    <#assign peers += ['glusterfs-${index}-${namespace}.1'] />
    <#assign volumes += ['glusterfs-${index}-${namespace}.1:/var/lib/glusterd/data'] />
  </#list>
  
  <@swarm.STORAGE 'swarmstorage-glusterfs-${namespace}' 'glusterfs-net-${namespace}' />
    
  <#list "1,2,3"?split(",") as index>
    <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
      <@swarm.VOLUME_RM 'glusterfs-data-volume-${index}-${namespace}' />
      <@swarm.VOLUME_RM 'glusterfs-log-volume-${index}-${namespace}' />
    </#if>

    <@swarm.TASK 'glusterfs-${index}-${namespace}'>
      <@container.NETWORK 'glusterfs-net-${namespace}' />
      <@container.VOLUME 'glusterfs-data-volume-${index}-${namespace}' '/var/lib/glusterd' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, PARAMS.VOLUME_SIZE_GB) />
      <@container.VOLUME 'glusterfs-log-volume-${index}-${namespace}' '/var/log/glusterfs' />
      <#if index?number == 3>
      <@container.ENV 'BUILD_NODE' 'true' />
      </#if>
      <@container.ENV 'PEERS' peers?join(" ") />
      <@container.ENV 'VOLUME_DRIVER' PARAMS.VOLUME_DRIVER />
      <@container.ENV 'VOLUMES' volumes?join(" ") />
      <@container.ENV 'VOLUMES_COUNT' '${volumes?size}' />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-glusterfs-${namespace}' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'glusterfs-${index}-${namespace}' 'imagenarium/glusterfs:3.13'>
      <@service.CONS 'node.labels.glusterfs' '${index}' />
    </@swarm.TASK_RUNNER>
  </#list>

  <@docker.HTTP_CHECKER 'gluster-checker-${namespace}' 'http://glusterfs-3-${namespace}.1:9200?action=check' 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>