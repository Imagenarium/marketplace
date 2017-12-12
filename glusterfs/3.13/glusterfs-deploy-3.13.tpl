<@requirement.HA />
<@requirement.CONS_HA 'glusterfs' 'true' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />

<@requirement.CONFORMS>
  <#assign NETMASK=randomNetmask16 />
  <@swarm.NETWORK 'glusterfs-net-${namespace}' '10.100.0.0/16' />
    
  <#assign peers = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign peers += ['glusterfs-${dc}-${namespace}.1'] />
  </@cloud.DATACENTER>
  
  <@swarm.SERVICE 'swarmstorage-glusterfs-${namespace}' 'imagenarium/swarmstorage:0.1'>
    <@service.NETWORK 'glusterfs-net-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.TASK 'glusterfs-${dc}-${namespace}' 'imagenarium/glusterfs:3.13u3'>
      <@container.NETWORK 'glusterfs-net-${namespace}' />    
      <@container.VOLUME 'glusterfs-data-volume-${dc}-${namespace}' '/gluster-data' />
      <@container.VOLUME 'glusterfs-log-volume-${dc}-${namespace}' '/var/log/glusterfs' />
      <#if index == 3>
      <@container.ENV 'PEERS' peers?join(" ") />
      </#if>
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-glusterfs-${namespace}' />
      <@container.ENV 'SERVICE_NAME' 'glusterfs-${dc}-${namespace}' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'glusterfs-${dc}-${namespace}'>
      <@service.DC dc />
      <@service.CONS 'node.labels.glusterfs' 'true' />
      <@service.ENV 'NETMASK' NETMASK />
      <@service.ENV 'SERVICE_INDEX' 100+index />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>