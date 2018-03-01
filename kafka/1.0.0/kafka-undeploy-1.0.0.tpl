<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'kafka-manager-checker-${namespace}' />

  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'kafka-${index}-${namespace}' />
    <@swarm.SERVICE_RM 'zookeeper-${index}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-kafka-${namespace}' />
  <@swarm.SERVICE_RM 'kafka-manager-${namespace}' />
  <@swarm.SERVICE_RM 'nginx-kafka-manager-${namespace}' />
  
  <@swarm.NETWORK_RM 'kafka-net-${namespace}' />
</@requirement.CONFORMS>
