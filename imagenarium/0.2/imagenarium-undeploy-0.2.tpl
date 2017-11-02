<@swarm.SERVICE_RM 'dockergc' />
<@swarm.SERVICE_RM 'drainpool' />
<@swarm.SERVICE_RM 'swarmview' />
<@swarm.SERVICE_RM 'introspector' />

<@cloud.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'logdog-${dc}' />
</@cloud.DATACENTER>
