<@requirement.CONFORMS>
  <@docker.CONTAINER_RM 'percona-node-checker-${namespace}' />
  <@swarm.SERVICE_RM 'percona-init-${namespace}' />

  <#list "3,2,1"?split(",") as rack>
    <@swarm.SERVICE_RM 'percona-master-rack${rack}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'percona-proxy-${namespace}' />
  <@swarm.NETWORK_RM 'percona-proxy-net-${namespace}' />
</@requirement.CONFORMS>
