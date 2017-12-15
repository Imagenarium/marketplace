<@requirement.HA />
<@requirement.CONS_HA 'glusterfs' 'true' />
<@requirement.NAMESPACE 'system' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'glusterfs-net-${namespace}' />  
    
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign peers += ['glusterfs-${dc}-${namespace}.1'] />
    <#assign volumes += ['glusterfs-${dc}-${namespace}.1:/gluster-data'] />
  </@cloud.DATACENTER>
  
  <@swarm.SERVICE 'swarmstorage-glusterfs-${namespace}' 'imagenarium/swarmstorage:0.1'>
    <@service.NETWORK 'glusterfs-net-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.TASK 'glusterfs-${dc}-${namespace}' 'imagenarium/glusterfs:3.13u23'>
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
      <@container.ENV 'SERVICE_NAME' 'glusterfs-${dc}-${namespace}' />
      <@container.ENV 'SERVICE_PORTS' '24007' />
      <@container.ENV 'TCP_PORTS' '24007' />
      <@container.ENV 'BALANCE' 'source' />
      <@container.ENV 'HEALTH_CHECK' 'check port 9200 inter 5000 rise 1 fall 2' />
      <@container.ENV 'OPTION' 'httpchk GET /?action=check HTTP/1.1\\r\\nHost:\\ www' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'glusterfs-${dc}-${namespace}'>
      <@service.DC dc />
      <@service.CONS 'node.labels.glusterfs' 'true' />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>

  <@swarm.SERVICE 'glusterfs-proxy-${namespace}' 'dockercloud/haproxy:latest'>
    <@service.NETWORK 'glusterfs-net-${namespace}' />
    <@service.DOCKER_SOCKET />
    <@node.MANAGER />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECK 'http://glusterfs-dc3-${namespace}.1:9200?action=check' 'glusterfs-net-${namespace}' />

<#--
  <@swarm.TASK 'glusterfs-client-${namespace}' 'imagenarium/glusterfs-client:3.13u2'>
    <@container.NETWORK 'glusterfs-net-${namespace}' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'glusterfs-client-${namespace}' 'global' />-->
</@requirement.CONFORMS>