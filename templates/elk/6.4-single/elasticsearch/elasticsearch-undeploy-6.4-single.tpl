<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'es-checker-${namespace}' />

  <@swarm.SERVICE_RM 'es-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-es-${namespace}' />
  
  <@swarm.NETWORK_RM 'es-net-${namespace}' />
</@requirement.CONFORMS>