<@requirement.CONFORMS>
  <@docker.CONTAINER_RM 'zookeeper-checker-${namespace}' />
  <@docker.CONTAINER_RM 'kafka-checker-${namespace}' />
  <@docker.CONTAINER_RM 'kafka-rest-checker-${namespace}' />
  
  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'kafka-${index}-${namespace}' />
    <@swarm.SERVICE_RM 'zookeeper-${index}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-kafka-${namespace}' />
  
  <@swarm.NETWORK_RM 'kafka-net-${namespace}' />
</@requirement.CONFORMS>
