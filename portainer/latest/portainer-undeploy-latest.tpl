<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECK />
  <@swarm.SERVICE_RM 'portainer-${namespace}' />
  <@swarm.NETWORK_RM 'portainer-net-${namespace}' />
</@requirement.CONFORMS>