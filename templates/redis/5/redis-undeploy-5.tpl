<@docker.CONTAINER_RM 'redis-checker-${namespace}' />

<@swarm.SERVICE_RM 'redis-${namespace}' />

<@swarm.NETWORK_RM 'redis-net-${namespace}' />
