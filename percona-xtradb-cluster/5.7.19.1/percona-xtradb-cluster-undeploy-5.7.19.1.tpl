<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'percona-init-${uniqueId}' />

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'percona-master-${dc}-${uniqueId}' />
    <@swarm.SERVICE_RM 'percona-proxy-${dc}-${uniqueId}' />
    <@swarm.NETWORK_RM 'percona-${dc}-${uniqueId}' />
  </@cloud.DATACENTER>

  <@swarm.NETWORK_RM 'percona-net-${uniqueId}' />
</@requirement.CONFORMS>
