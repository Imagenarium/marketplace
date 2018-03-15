<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'es-checker-${namespace}' />

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'es-master-${index}-${namespace}' />
    <@swarm.SERVICE_RM 'es-worker-${index}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'es-router-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-es-${namespace}' />
  
  <@swarm.NETWORK_RM 'es-net-${namespace}' />
</@requirement.CONFORMS>