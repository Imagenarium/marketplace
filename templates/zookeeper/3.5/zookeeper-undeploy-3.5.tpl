<@docker.CONTAINER_RM 'zookeeper-checker-${namespace}' />

<#list 1..3 as index>
  <@swarm.SERVICE_RM 'zookeeper-${index}-${namespace}' />
</#list>

<@swarm.SERVICE_RM 'zookeeper-exporter-${namespace}' />

<@swarm.NETWORK_RM 'net-${namespace}' />
