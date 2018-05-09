<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'cockroach-checker-${namespace}' />

  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'cockroachdb-${index}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-cockroach-${namespace}' />  
  <@swarm.NETWORK_RM 'cockroach-net-${namespace}' />
</@requirement.CONFORMS>
