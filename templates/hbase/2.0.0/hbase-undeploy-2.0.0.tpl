<@docker.REMOVE_HTTP_CHECKER 'hdfs-checker-${namespace}' />

<@swarm.SERVICE_RM 'hdfs-name-${namespace}' />
<@swarm.SERVICE_RM 'hbase-master-${namespace}' />

<#list 1..3 as index>
  <@swarm.SERVICE_RM 'hbase-${index}-${namespace}' />
</#list>
 
<@swarm.NETWORK_RM 'net-${namespace}' />
