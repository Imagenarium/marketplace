<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'portainer-${uniqueId}' />
  <@swarm.NETWORK_RM 'portainer-net-${uniqueId}' />
</@requirement.CONFORMS>