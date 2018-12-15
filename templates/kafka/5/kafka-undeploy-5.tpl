<@docker.CONTAINER_RM 'kafka-checker-${namespace}' />
  
<#list 1..3 as index>
  <@swarm.SERVICE_RM 'kafka-${index}-${namespace}' />  
</#list>

<@swarm.SERVICE_RM 'kafka-exporter-${namespace}' />
<@swarm.SERVICE_RM 'prometheus-${namespace}' />
<@swarm.SERVICE_RM 'grafana-${namespace}' />

<@swarm.NETWORK_RM 'net-${namespace}' />
