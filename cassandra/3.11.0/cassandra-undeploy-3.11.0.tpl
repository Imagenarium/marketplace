<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'cassandra-seed-${dc}' />
</@node.DATACENTER>

<@swarm.SERVICE_RM 'swarmstorage-cassandra' />

<@swarm.NETWORK_RM 'cassandra-net' />
