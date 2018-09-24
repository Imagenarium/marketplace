<@requirement.CONFORMS>
  <@docker.CONTAINER_RM 'percona-checker-${namespace}' />
  <@swarm.SERVICE_RM 'percona-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-percona-${namespace}' />
  <@swarm.NETWORK_RM 'net-${namespace}' />
</@requirement.CONFORMS>
