<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'jenkins-master-${uniqueId}' />
  <@swarm.SERVICE_RM 'jenkins-slave-${uniqueId}' />

  <@swarm.NETWORK_RM 'jenkins-net-${uniqueId}' />
</@requirement.CONFORMS>