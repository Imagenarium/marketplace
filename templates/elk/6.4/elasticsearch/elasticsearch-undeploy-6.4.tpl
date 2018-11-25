<@docker.REMOVE_HTTP_CHECKER 'es-checker-${namespace}' />

<#list "1,2,3"?split(",") as index>
  <@swarm.SERVICE_RM 'es-master-${index}-${namespace}' />
</#list>

<@swarm.SERVICE_RM 'es-router-${namespace}' />
  
<@swarm.NETWORK_RM 'es-net-${namespace}' />