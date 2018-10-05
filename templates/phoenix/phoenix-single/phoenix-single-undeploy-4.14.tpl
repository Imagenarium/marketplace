<@requirement.CONFORMS>
  <@docker.REMOVE_TCP_CHECKER 'phoenix-checker-${namespace}' />

  <@swarm.SERVICE_RM 'phoenix-${namespace}' />

  <@swarm.NETWORK_RM 'net-${namespace}' />
</@requirement.CONFORMS>