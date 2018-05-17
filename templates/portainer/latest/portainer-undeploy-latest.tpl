<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'portainer-checker-${namespace}' />
  <@swarm.SERVICE_RM 'portainer-${namespace}' />
  <@swarm.NETWORK_RM 'portainer-net-${namespace}' />
</@requirement.CONFORMS>