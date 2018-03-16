<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'portainer-checker-${namespace}' />
  <@swarm.SERVICE_RM 'portainer-${namespace}' />
</@requirement.CONFORMS>