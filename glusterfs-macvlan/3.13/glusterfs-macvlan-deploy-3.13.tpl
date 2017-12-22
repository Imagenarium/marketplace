<@requirement.NAMESPACE 'system' />
<@requirement.CONS 'glusterfs-1' 'true' />
<@requirement.CONS 'glusterfs-2' 'true' />
<@requirement.CONS 'glusterfs-3' 'true' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='MACVLAN_PREFIX' value='10.99' />
<@requirement.PARAM name='MACVLAN_DEVICE' value='enp0s8.99' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'glusterfs-overlay-net-${namespace}' />  
    
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <#list 1..3 as index>
    <#assign peers += ['${PARAMS.MACVLAN_PREFIX}.${index}.1'] />
    <#assign volumes += ['${PARAMS.MACVLAN_PREFIX}.${index}.1:/gluster-data'] />
  </#list>
  
  <@swarm.SERVICE 'swarmstorage-glusterfs-${namespace}' 'imagenarium/swarmstorage:0.5.0'>
    <@service.NETWORK 'glusterfs-overlay-net-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
    
  <#list 1..3 as index>
    <@swarm.TASK 'glusterfs-${index}-${namespace}' 'imagenarium/glusterfs:3.13u25'>
      <@container.NETWORK 'glusterfs-overlay-net-${namespace}' />
      <@container.NETWORK name='glusterfs-macvlan-net-${namespace}' type='macvlan' macvlan_prefix=PARAMS.MACVLAN_PREFIX macvlan_service_id=index macvlan_device=PARAMS.MACVLAN_DEVICE />
      <@container.VOLUME 'glusterfs-data-volume-${index}-${namespace}' '/gluster-data' />
      <@container.VOLUME 'glusterfs-log-volume-${index}-${namespace}' '/var/log/glusterfs' />
      <@container.VOLUME 'glusterfs-lib-volume-${index}-${namespace}' '/var/lib/glusterd' />
      <#if index == 3>
      <@container.ENV 'BUILD_NODE' 'true' />
      </#if>
      <@container.ENV 'PEERS' peers?join(" ") />
      <@container.ENV 'VOLUMES' volumes?join(" ") />
      <@container.ENV 'VOLUMES_COUNT' volumes?size />
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-glusterfs-${namespace}' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'glusterfs-${index}-${namespace}'>
      <@service.CONS 'node.labels.glusterfs-${index}' 'true' />
    </@swarm.TASK_RUNNER>
  </#list>

  <@docker.HTTP_CHECK 'http://glusterfs-3-${namespace}.1:9200?action=check' 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>