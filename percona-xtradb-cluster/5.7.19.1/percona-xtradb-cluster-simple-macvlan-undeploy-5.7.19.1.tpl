<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'percona-init-${namespace}' />
  <@swarm.SERVICE_RM 'percona-master-${namespace}' />
  <@swarm.SERVICE_RM 'percona-proxy-${namespace}' />
  sleep 5
  <@swarm.NETWORK_RM 'percona-net-overlay-${namespace}' />
</@requirement.CONFORMS>
