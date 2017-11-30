<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'kibana-${uniqueId}' />
  <@swarm.SERVICE_RM 'nginx-kibana-${uniqueId}' />

  <@swarm.NETWORK_RM 'es-net-${uniqueId}' />
</@requirement.CONFORMS>
