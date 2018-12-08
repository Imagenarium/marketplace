<#list 1..3 as index>
  <@swarm.SERVICE_RM 'hdfs-data-${index}-${namespace}' />
</#list>

<#list 1..2 as index>
  <@swarm.SERVICE_RM 'hdfs-name-${index}-${namespace}' />
</#list>

<#list 1..3 as index>
  <@swarm.SERVICE_RM 'hdfs-journal-${index}-${namespace}' />
</#list>
 
<@swarm.NETWORK_RM 'net-${namespace}' />
