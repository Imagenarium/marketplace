<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'gitlab-${namespace}' />
  <@swarm.NETWORK_RM 'gitlab-net-${namespace}' />
  <@docker.REMOVE_HTTP_CHECKER 'gitlab-checker-${namespace}' />
</@requirement.CONFORMS>
