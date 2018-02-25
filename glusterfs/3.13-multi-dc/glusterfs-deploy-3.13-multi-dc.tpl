<@requirement.HA />

<@requirement.CONS_HA 'glusterfs' 'true' />

<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DATA_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='LOG_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='LIB_VOLUME_OPTS' value=' ' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='glusterfs-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />  
    
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign peers += ['glusterfs-${dc}-${namespace}.1'] />
    <#assign volumes += ['glusterfs-${dc}-${namespace}.1:/gluster-data'] />
  </@cloud.DATACENTER>
  
  <@swarm.STORAGE 'swarmstorage-glusterfs-${namespace}' 'glusterfs-net-${namespace}' />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.TASK 'glusterfs-${dc}-${namespace}'>
      <@container.NETWORK 'glusterfs-net-${namespace}' />
      <@container.VOLUME 'glusterfs-data-volume-${dc}-${namespace}' '/gluster-data' PARAMS.VOLUME_DRIVER PARAMS.DATA_VOLUME_OPTS?trim />
      <@container.VOLUME 'glusterfs-log-volume-${dc}-${namespace}' '/var/log/glusterfs' PARAMS.VOLUME_DRIVER PARAMS.LOG_VOLUME_OPTS?trim />
      <@container.VOLUME 'glusterfs-lib-volume-${dc}-${namespace}' '/var/lib/glusterd' PARAMS.VOLUME_DRIVER PARAMS.LIB_VOLUME_OPTS?trim />
      <#if index == 3>
      <@container.ENV 'BUILD_NODE' 'true' />
      </#if>
      <@container.ENV 'PEERS' peers?join(" ") />
      <@container.ENV 'VOLUME_DRIVER' PARAMS.VOLUME_DRIVER />
      <@container.ENV 'VOLUMES' volumes?join(" ") />
      <@container.ENV 'VOLUMES_COUNT' volumes?size />
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-glusterfs-${namespace}' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'glusterfs-${dc}-${namespace}' 'imagenarium/glusterfs:3.13u27'>
      <@service.DC dc />
      <@service.CONS 'node.labels.glusterfs' 'true' />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>

  <@docker.HTTP_CHECK 'http://glusterfs-dc3-${namespace}.1:9200?action=check' 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>