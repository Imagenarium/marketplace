<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'cassandra-seed-${dc}' />
</@node.DATACENTER>

<@swarm.SERVICE_RM 'swarmstorage' />

<@swarm.NETWORK_RM 'cassandra-net' />
