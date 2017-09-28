<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'etcd-${dc}' />
</@node.DATACENTER>

<@swarm.NETWORK_RM 'etcd-net' />
