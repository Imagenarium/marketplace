<#list 1..3 as index>
  <@swarm.SERVICE_RM 'hbase-region-${index}-${namespace}' />
  <@swarm.SERVICE_RM 'hbase-master-${index}-${namespace}' />
</#list>
 
<@swarm.NETWORK_RM 'net-${namespace}' />
