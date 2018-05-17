<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'traefik-checker-${namespace}' />
  <@swarm.SERVICE_RM 'traefik-${namespace}' />
  <@swarm.NETWORK_RM 'traefik-net-${namespace}' />
</@requirement.CONFORMS>