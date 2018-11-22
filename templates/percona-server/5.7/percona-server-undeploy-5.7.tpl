<@docker.CONTAINER_RM 'percona-checker-${namespace}' />
<@docker.CONTAINER_RM 'pmm-checker-${namespace}' />
<@swarm.SERVICE_RM 'percona-${namespace}' />
<@swarm.SERVICE_RM 'pmm-${namespace}' />
<@swarm.NETWORK_RM 'net-${namespace}' />