<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'postgres-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-postgres-${namespace}' />
  <@swarm.NETWORK_RM 'postgres-net-${namespace}' />
</@requirement.CONFORMS>
