<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'processor-checker-${namespace}' />
  <@swarm.SERVICE_RM 'invoice-processor-${namespace}' />
  <@swarm.NETWORK_RM 'kafka-net-${namespace}' />
</@requirement.CONFORMS>
