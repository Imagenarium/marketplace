<@docker.CONTAINER_RM 'postgres-checker-${namespace}' />
<@docker.CONTAINER_RM 'pmm-checker-${namespace}' />
<@swarm.SERVICE_RM 'postgres-${namespace}' />
<@swarm.SERVICE_RM 'pmm-${namespace}' />
<@swarm.NETWORK_RM 'postgres-net-${namespace}' />

