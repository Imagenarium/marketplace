<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'hdfs-checker-${namespace}' />
  <@docker.CONTAINER_RM 'zookeeper-checker-${namespace}' />

  <@swarm.SERVICE_RM 'hdfs-name-${namespace}' />

  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'hdfs-data-${index}-${namespace}' />
  </#list>

  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'zookeeper-${index}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-hadoop-${namespace}' />
  
  <@swarm.NETWORK_RM 'hadoop-net-${namespace}' />
</@requirement.CONFORMS>