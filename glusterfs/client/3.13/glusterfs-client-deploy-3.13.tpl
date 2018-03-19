<@requirement.CONFORMS>  
  <#assign peers = [] />
    
  <#list "1,2,3"?split(",") as index>
    <#assign peers += ['glusterfs-${index}-${namespace}.1'] />
  </#list>

  <@swarm.TASK 'glusterfs-client-${namespace}'>
    <@container.NETWORK 'glusterfs-net-${namespace}' />
    <@container.ENV 'PEERS' peers?join(" ") />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'glusterfs-client-${namespace}' 'imagenarium/glusterfs-client:3.13' />
</@requirement.CONFORMS>