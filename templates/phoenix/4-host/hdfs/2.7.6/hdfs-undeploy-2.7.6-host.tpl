<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'hdfs-checker-${namespace}' />

  <@swarm.SERVICE_RM 'hdfs-name-${namespace}' />

  <#list 1..3 as index>
    <@swarm.SERVICE_RM 'hdfs-data-${index}-${namespace}' />
  </#list>
</@requirement.CONFORMS>