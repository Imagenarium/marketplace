<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'logstash-checker-${namespace}' />

  <@swarm.SERVICE_RM 'logstash-${namespace}' />

  <@swarm.NETWORK_RM 'es-net-${namespace}' />
</@requirement.CONFORMS>