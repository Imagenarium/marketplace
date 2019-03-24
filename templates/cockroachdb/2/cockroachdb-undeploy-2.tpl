<@docker.REMOVE_HTTP_CHECKER 'cluster-checker-${namespace}' />

<#list 1..3 as index>
  <@swarm.SERVICE_RM 'cockroachdb-${index}-${namespace}' />
  <@swarm.SERVICE_RM 'nginx-cockroachdb-${index}-${namespace}' />
</#list>

<@swarm.NETWORK_RM 'net-${namespace}' />