<@requirement.CONFORMS>
  <@docker.REMOVE_TCP_CHECKER 'phoenix-checker-${namespace}' />

  <@swarm.SERVICE_RM 'phoenix-${namespace}' />
</@requirement.CONFORMS>