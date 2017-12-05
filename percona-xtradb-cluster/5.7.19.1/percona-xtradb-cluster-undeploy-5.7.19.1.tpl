<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'percona-init-${namespace}' />

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'percona-master-${dc}-${namespace}' />
    <@swarm.SERVICE_RM 'percona-proxy-${dc}-${namespace}' />
    <@swarm.NETWORK_RM 'percona-${dc}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.NETWORK_RM 'percona-net-${namespace}' />
</@requirement.CONFORMS>
