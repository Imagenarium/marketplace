<@requirement.CONFORMS>  
  <#assign peers = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign peers += ['glusterfs-${index}-${namespace}.1'] />
  </@cloud.DATACENTER>

  <@swarm.TASK 'glusterfs-client-${namespace}'>
    <@container.NETWORK 'glusterfs-net-${namespace}' />
    <@container.ENV 'PEERS' peers?join(" ") />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'glusterfs-client-${namespace}' 'imagenarium/glusterfs-client:3.13u5' />
</@requirement.CONFORMS>