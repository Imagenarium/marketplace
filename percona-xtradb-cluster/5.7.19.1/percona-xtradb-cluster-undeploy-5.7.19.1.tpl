<@requirement.PARAM 'stackId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'percona-init-${stackId}' />

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'percona-master-${dc}-${stackId}' />
    <@swarm.SERVICE_RM 'percona-proxy-${dc}-${stackId}' />
    <@swarm.NETWORK_RM 'percona-${dc}-${stackId}' />
  </@cloud.DATACENTER>

  <@swarm.NETWORK_RM 'percona-net-${stackId}' />
</@requirement.CONFORMS>
