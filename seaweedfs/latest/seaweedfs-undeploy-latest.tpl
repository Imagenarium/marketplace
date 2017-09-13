<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'weed-master-${dc}' />
  <@swarm.SERVICE_RM 'weed-volume-${dc}' />
</@node.DATACENTER>

<@swarm.NETWORK_RM 'weed-network' />