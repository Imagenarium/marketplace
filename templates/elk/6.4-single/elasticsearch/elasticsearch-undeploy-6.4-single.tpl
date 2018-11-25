<@docker.REMOVE_HTTP_CHECKER 'es-checker-${namespace}' />

<@swarm.SERVICE_RM 'es-${namespace}' />
  
<@swarm.NETWORK_RM 'es-net-${namespace}' />
