<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'gluster-checker-${namespace}' />

  <#list "1,2,3"?split(",") as index>
    <@swarm.SERVICE_RM 'glusterfs-${index}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-glusterfs-${namespace}' />
  <@swarm.NETWORK_RM 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>
