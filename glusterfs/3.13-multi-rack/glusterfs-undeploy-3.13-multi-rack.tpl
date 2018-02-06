<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECK />

  <#list "1,2,3"?split(",") as rack>
    <@swarm.SERVICE_RM 'glusterfs-rack${rack}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-glusterfs-${namespace}' />
  <@swarm.NETWORK_RM 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>
