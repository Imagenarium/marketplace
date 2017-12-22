<@requirement.CONFORMS>
  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'glusterfs-${index}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-glusterfs-${namespace}' />
</@requirement.CONFORMS>
