<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'kibana-${uniqueId}' />
  <@swarm.SERVICE_RM 'nginx-kibana-${uniqueId}' />
</@requirement.CONFORMS>
