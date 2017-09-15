<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'kafka-${dc}' />
  <@swarm.SERVICE_RM 'zookeeper-${dc}' />
</@node.DATACENTER>

<@swarm.SERVICE_RM 'kafka-manager' />

<@swarm.NETWORK_RM 'kafka-net' />
