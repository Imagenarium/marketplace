<@requirement.HA />
<@requirement.CONS_HA 'glusterfs' 'true' />
<@requirement.NAMESPACE 'system' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='PUBLISHED_PORT' value='24007' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'glusterfs-net-${namespace}' />  
    
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign peers += ['glusterfs-${dc}-${namespace}.1'] />
    <#assign volumes += ['glusterfs-${dc}-${namespace}.1:/gluster-data/default'] />
  </@cloud.DATACENTER>
  
  <@swarm.SERVICE 'swarmstorage-glusterfs-${namespace}' 'imagenarium/swarmstorage:0.1'>
    <@service.NETWORK 'glusterfs-net-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.TASK 'glusterfs-${dc}-${namespace}' 'imagenarium/glusterfs:3.13u12'>
      <@container.NETWORK 'glusterfs-net-${namespace}' />
      <@container.NETWORK 'ingress' />
      <@container.PORT PARAMS.PUBLISHED_PORT '24007' />
      <@container.VOLUME 'glusterfs-data-volume-${dc}-${namespace}' '/gluster-data' />
      <@container.VOLUME 'glusterfs-log-volume-${dc}-${namespace}' '/var/log/glusterfs' />
      <@container.VOLUME 'glusterfs-lib-volume-${dc}-${namespace}' '/var/lib/glusterd' />
      <#if index == 3>
      <@container.ENV 'BUILD_NODE' 'true' />
      </#if>
      <@container.ENV 'PEERS' peers?join(" ") />
      <@container.ENV 'VOLUMES' volumes?join(" ") />
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-glusterfs-${namespace}' />
      <@container.ENV 'SERVICE_NAME' 'glusterfs-${dc}-${namespace}' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'glusterfs-${dc}-${namespace}'>
      <@service.DC dc />
      <@service.CONS 'node.labels.glusterfs' 'true' />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>