<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'swarmview-${uniqueId}' />
  <@swarm.SERVICE_RM 'introspector-${uniqueId}' />

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'logdog-${dc}-${uniqueId}' />
  </@cloud.DATACENTER>

  <@swarm.NETWORK_RM 'es-net-${uniqueId}' />
</@requirement.CONFORMS>
