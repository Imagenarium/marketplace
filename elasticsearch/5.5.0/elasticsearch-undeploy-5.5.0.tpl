<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'es-master-${dc}' />
</@node.DATACENTER>

<@swarm.SERVICE_RM 'es-router' />

