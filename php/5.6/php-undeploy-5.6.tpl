<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECK />
  <@swarm.SERVICE_RM 'apache-php-${namespace}' />
  <@swarm.NETWORK_RM 'frontend-net-${namespace}' />
</@requirement.CONFORMS>
