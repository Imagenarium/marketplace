<@docker.REMOVE_HTTP_CHECKER 'checker-${namespace}' />

<@swarm.SERVICE_RM 'hdfs-name-${namespace}' />

<#list 1..3 as index>
  <@swarm.SERVICE_RM 'hdfs-${index}-${namespace}' />
</#list>
 
<@swarm.NETWORK_RM 'net-${namespace}' />
