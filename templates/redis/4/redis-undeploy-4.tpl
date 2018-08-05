<@requirement.CONFORMS>
  <@docker.CONTAINER_RM 'redis-checker-${namespace}' />
  <@swarm.SERVICE_RM 'redis-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-redis-${namespace}' />
  <@swarm.NETWORK_RM 'redis-net-${namespace}' />
</@requirement.CONFORMS>
