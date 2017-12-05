<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'es-master-${dc}-${namespace}' />
    <@swarm.SERVICE_RM 'es-worker-${dc}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'es-router-${namespace}' />
  
  <@swarm.NETWORK_RM 'es-net-${namespace}' />
</@requirement.CONFORMS>