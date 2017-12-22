<@requirement.CONFORMS>
  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'glusterfs-${index}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-glusterfs-${namespace}' />

  sleep 5
  <@swarm.NETWORK_RM 'glusterfs-overlay-net-${namespace}' />
</@requirement.CONFORMS>
