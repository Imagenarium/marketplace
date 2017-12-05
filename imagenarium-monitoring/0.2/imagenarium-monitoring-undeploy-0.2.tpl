<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'swarmview-${namespace}' />
  <@swarm.SERVICE_RM 'introspector-${namespace}' />

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'logdog-${dc}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.NETWORK_RM 'es-net-${namespace}' />
</@requirement.CONFORMS>
