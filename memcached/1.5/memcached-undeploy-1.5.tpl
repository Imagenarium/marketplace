<@requirement.CONFORMS>
  <@docker.CONTAINER_RM 'memcached-checker-${namespace}' />
  <@swarm.SERVICE_RM 'memcached-${namespace}' />
  <@swarm.NETWORK_RM 'sylex-net-${namespace}' />
</@requirement.CONFORMS>
