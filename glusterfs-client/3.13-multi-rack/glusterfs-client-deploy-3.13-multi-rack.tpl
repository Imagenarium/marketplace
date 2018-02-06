<@requirement.CONFORMS>  
  <#assign peers = [] />
    
  <#list "1,2,3"?split(",") as rack>
    <#assign peers += ['glusterfs-rack${rack}-${namespace}.1'] />
  </#list>

  <@swarm.TASK 'glusterfs-client-${namespace}' 'imagenarium/glusterfs-client:3.13u5'>
    <@container.NETWORK 'glusterfs-net-${namespace}' />
    <@container.ENV 'PEERS' peers?join(" ") />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'glusterfs-client-${namespace}' />
</@requirement.CONFORMS>