<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'invoice-sender-${uniqueId}' />

  <@swarm.NETWORK_RM 'kafka-net-${uniqueId}' />
</@requirement.CONFORMS>
