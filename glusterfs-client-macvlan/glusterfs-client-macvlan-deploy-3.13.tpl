<@requirement.NAMESPACE 'system' />
<@requirement.PARAM name='MACVLAN_PREFIX' value='10.33' />
<@requirement.PARAM name='MACVLAN_DEVICE' value='ens7.33' />

<@requirement.CONFORMS>  
  <#assign peers = [] />
    
  <#list 1..3 as index>
    <#assign peers += ['${PARAMS.MACVLAN_PREFIX}.${index}.1'] />
  </#list>

  <@swarm.TASK 'glusterfs-client-${namespace}' 'imagenarium/glusterfs-client:3.13u5'>
    <@container.NETWORK name='glusterfs-macvlan-net-${namespace}' type='macvlan' macvlan_prefix=PARAMS.MACVLAN_PREFIX macvlan_service_id=55 macvlan_device=PARAMS.MACVLAN_DEVICE />
    <@container.ENV 'PEERS' peers?join(" ") />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'glusterfs-client-${namespace}' 'global' />
</@requirement.CONFORMS>