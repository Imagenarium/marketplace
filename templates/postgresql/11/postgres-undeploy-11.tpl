<@docker.CONTAINER_RM 'postgres-checker-${namespace}' />

<@swarm.SERVICE_RM 'postgres-${namespace}' />

<@swarm.NETWORK_RM 'postgres-net-${namespace}' />

