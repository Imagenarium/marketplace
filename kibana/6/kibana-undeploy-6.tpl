<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'kibana-${namespace}' />
  <@swarm.SERVICE_RM 'nginx-kibana-${namespace}' />

  <@swarm.NETWORK_RM 'es-net-${namespace}' />
</@requirement.CONFORMS>
