<@swarm.SERVICE_RM 'percona-init' />

<@cloud.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'percona-master-${dc}' />
  <@swarm.SERVICE_RM 'percona-proxy-${dc}' />
  <@swarm.NETWORK_RM 'percona-${dc}' />
</@cloud.DATACENTER>

<@swarm.NETWORK_RM 'percona-net' />
<@swarm.NETWORK_RM 'haproxy-monitoring' />

