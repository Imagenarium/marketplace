<@requirement.CONFORMS>
  <@docker.CONTAINER_RM 'oracle-checker-${namespace}' />
  <@swarm.SERVICE_RM 'oracle-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-oracle-${namespace}' />
  <@swarm.NETWORK_RM 'network-${namespace}' />
</@requirement.CONFORMS>
