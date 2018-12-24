<@docker.CONTAINER_RM 'percona-node-checker-${namespace}' />

<@swarm.SERVICE_RM 'percona-init-${namespace}' />

<#list "3,2,1"?split(",") as index>
  <@swarm.SERVICE_RM 'percona-${index}-${namespace}' />
</#list>

<@swarm.NETWORK_RM 'percona-net-${namespace}' />