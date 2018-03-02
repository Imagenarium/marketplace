<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'sender-checker-${namespace}' />
  <@swarm.SERVICE_RM 'invoice-sender-${namespace}' />
  <@swarm.NETWORK_RM 'kafka-net-${namespace}' />
</@requirement.CONFORMS>
