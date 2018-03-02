<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'servicedesk-checker-${namespace}' />
  <@swarm.SERVICE_RM 'servicedesk-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-servicedesk-${namespace}' />
  <@swarm.NETWORK_RM 'network-${namespace}' />
</@requirement.CONFORMS>
