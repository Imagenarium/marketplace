<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'gitea-checker-${namespace}' />
  <@swarm.SERVICE_RM 'gitea-${namespace}' />
</@requirement.CONFORMS>
