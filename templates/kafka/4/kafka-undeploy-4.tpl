<@docker.CONTAINER_RM 'kafka-checker-${namespace}' />
  
<#list 1..3 as index>
  <@swarm.SERVICE_RM 'kafka-${index}-${namespace}' />  
</#list>

<@swarm.NETWORK_RM 'net-${namespace}' />
