<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'swarmstorage-registry-${namespace}' />
  <@swarm.SERVICE_RM 'registry-${namespace}' />
  <@swarm.NETWORK_RM 'registry-net-${namespace}' />
</@requirement.CONFORMS>