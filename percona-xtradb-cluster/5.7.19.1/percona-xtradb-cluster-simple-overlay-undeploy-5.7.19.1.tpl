<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'percona-init-${namespace}' />
  <@swarm.SERVICE_RM 'percona-master-${namespace}' />
  <@swarm.SERVICE_RM 'percona-proxy-${namespace}' />

  <@swarm.NETWORK_RM 'percona-net-${namespace}' />
</@requirement.CONFORMS>
