<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'zookeeper-${dc}' />
</@node.DATACENTER>

<@swarm.SERVICE_RM 'swarmstorage-zookeeper' />

<@swarm.NETWORK_RM 'zookeeper-net' />
