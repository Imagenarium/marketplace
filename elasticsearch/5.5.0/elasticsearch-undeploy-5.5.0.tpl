<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'es-master-${dc}' />
  <@swarm.SERVICE_RM 'es-worker-${dc}' />
</@node.DATACENTER>

<@swarm.SERVICE_RM 'es-router' />

