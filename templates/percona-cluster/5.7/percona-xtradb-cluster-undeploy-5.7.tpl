<@docker.CONTAINER_RM 'percona-node-checker-${namespace}' />

<@docker.CONTAINER_RM 'percona-init-${namespace}' />

<#list "3,2,1"?split(",") as index>
  <@swarm.SERVICE_RM 'percona-${index}-${namespace}' />
</#list>

<@swarm.SERVICE_RM 'proxysql-${namespace}' />
<@swarm.SERVICE_RM 'pmm-${namespace}' />
<@swarm.SERVICE_RM 'nginx-pmm-${namespace}' />

<@swarm.NETWORK_RM 'percona-net-${namespace}' />