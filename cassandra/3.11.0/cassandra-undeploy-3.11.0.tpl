<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'cassandra-${dc}' />
</@node.DATACENTER>

<@swarm.SERVICE_RM 'cassandraagent' />

<@swarm.NETWORK_RM 'cassandra-net' />
