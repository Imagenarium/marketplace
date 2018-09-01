<@requirement.CONFORMS>
  <@docker.CONTAINER_RM 'etcd-checker-${namespace}' />

  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'etcd-${index}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-etcd-${namespace}' />
  
  <@swarm.NETWORK_RM 'net-${namespace}' />
</@requirement.CONFORMS>