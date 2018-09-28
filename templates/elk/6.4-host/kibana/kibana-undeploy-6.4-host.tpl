<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'kibana-checker-${namespace}' />

  <@swarm.SERVICE_RM 'kibana-${namespace}' />
</@requirement.CONFORMS>
