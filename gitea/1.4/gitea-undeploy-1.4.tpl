<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'gitea-checker-${namespace}' />
  <@swarm.SERVICE_RM 'gitea-${namespace}' />
  <@swarm.NETWORK_RM 'gitea-net-${namespace}' />
</@requirement.CONFORMS>
