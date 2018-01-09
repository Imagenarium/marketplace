<@requirement.HA />
<@requirement.CONS_HA 'glusterfs' 'true' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'glusterfs-net-${namespace}' />  
    
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign peers += ['glusterfs-${dc}-${namespace}.1'] />
    <#assign volumes += ['glusterfs-${dc}-${namespace}.1:/gluster-data'] />
  </@cloud.DATACENTER>
  
  <@swarm.SERVICE 'swarmstorage-glusterfs-${namespace}' 'imagenarium/swarmstorage:0.5.0'>
    <@service.NETWORK 'glusterfs-net-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.TASK 'glusterfs-${dc}-${namespace}' 'imagenarium/glusterfs:3.13u26'>
      <@container.NETWORK 'glusterfs-net-${namespace}' />
      <@container.VOLUME 'glusterfs-data-volume-${dc}-${namespace}' '/gluster-data' />
      <@container.VOLUME 'glusterfs-log-volume-${dc}-${namespace}' '/var/log/glusterfs' />
      <@container.VOLUME 'glusterfs-lib-volume-${dc}-${namespace}' '/var/lib/glusterd' />
      <#if index == 3>
      <@container.ENV 'BUILD_NODE' 'true' />
      </#if>
      <@container.ENV 'PEERS' peers?join(" ") />
      <@container.ENV 'VOLUMES' volumes?join(" ") />
      <@container.ENV 'VOLUMES_COUNT' volumes?size />
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-glusterfs-${namespace}' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'glusterfs-${dc}-${namespace}'>
      <@service.DC dc />
      <@service.CONS 'node.labels.glusterfs' 'true' />
      <@service.ENV 'SERVICE_PORTS' '9200' />
      <@service.HEALTH_CHECK 'curl -XGET http://127.0.0.1:9200?action=check' />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>