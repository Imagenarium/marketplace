<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'swarmstorage-gitlab-${namespace}' />
  <@swarm.SERVICE_RM 'gitlab-${namespace}' />
  <@docker.REMOVE_HTTP_CHECKER 'gitlab-checker-${namespace}' />
  <@swarm.NETWORK_RM 'gitlab-net-${namespace}' />
</@requirement.CONFORMS>
