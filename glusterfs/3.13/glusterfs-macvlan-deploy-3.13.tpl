<@requirement.CONS 'glusterfs' 'rack1' />
<@requirement.CONS 'glusterfs' 'rack2' />
<@requirement.CONS 'glusterfs' 'rack3' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='MACVLAN_PREFIX' value='10.33' />
<@requirement.PARAM name='MACVLAN_DEVICE' value='ens7.33' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'glusterfs-overlay-net-${namespace}' />  
    
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <#list 1..3 as index>
    <#assign peers += ['${PARAMS.MACVLAN_PREFIX}.${index}.1'] />
    <#assign volumes += ['${PARAMS.MACVLAN_PREFIX}.${index}.1:/gluster-data'] />
  </#list>
  
  <@swarm.STORAGE 'swarmstorage-glusterfs-${namespace}' 'glusterfs-overlay-net-${namespace}' />
    
  <#list 1..3 as index>
    <@swarm.TASK 'glusterfs-${index}-${namespace}' 'imagenarium/glusterfs:3.13u26'>
      <@container.NETWORK 'glusterfs-overlay-net-${namespace}' />
      <@container.NETWORK name='glusterfs-net-${namespace}' type='macvlan' macvlan_prefix=PARAMS.MACVLAN_PREFIX macvlan_service_id=index macvlan_device=PARAMS.MACVLAN_DEVICE />
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
      <@service.CONS 'node.labels.glusterfs' 'rack${index}' />
      <@service.ENV 'SERVICE_PORTS' '9200' />
      <@service.HEALTH_CHECK 'curl -XGET http://127.0.0.1:9200?action=check' />
    </@swarm.TASK_RUNNER>
  </#list>
</@requirement.CONFORMS>