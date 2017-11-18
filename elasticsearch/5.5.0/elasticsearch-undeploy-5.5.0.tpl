<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'es-master-${dc}-${uniqueId}' />
    <@swarm.SERVICE_RM 'es-worker-${dc}-${uniqueId}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'es-router-${uniqueId}' />
  
  set +e
  <@swarm.NETWORK_RM 'es-net-${uniqueId}' />
</@requirement.CONFORMS>