<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'portainer-checker-${namespace}' />
  <@swarm.SERVICE_RM 'portainer-${namespace}' />
  <@swarm.SERVICE_RM 'portainer-agent-${namespace}' />
  <@swarm.NETWORK_RM 'portainer-net-${namespace}' />
</@requirement.CONFORMS>