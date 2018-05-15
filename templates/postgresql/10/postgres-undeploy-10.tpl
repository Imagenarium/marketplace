<@requirement.CONFORMS>
  <@docker.CONTAINER_RM 'postgres-checker-${namespace}' />
  <@swarm.SERVICE_RM 'postgres-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-postgres-${namespace}' />
  <@swarm.NETWORK_RM 'postgres-net-${namespace}' />
</@requirement.CONFORMS>
