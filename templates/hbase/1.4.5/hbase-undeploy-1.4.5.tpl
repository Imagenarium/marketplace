<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'hbase-checker-${namespace}' />

  <@swarm.SERVICE_RM 'hbase-master-${namespace}' />

  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'hbase-regionserver-${index}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'swarmstorage-hbase-${namespace}' />
  
  <@swarm.NETWORK_RM 'hadoop-net-${namespace}' />
</@requirement.CONFORMS>