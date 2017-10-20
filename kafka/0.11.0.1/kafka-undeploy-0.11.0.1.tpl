<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'kafka-${dc}' />
  <@swarm.SERVICE_RM 'zookeeper-${dc}' />
</@node.DATACENTER>

<@swarm.SERVICE_RM 'swarmstorage-kafka' />
<@swarm.SERVICE_RM 'kafka-manager' />
<@swarm.SERVICE_RM 'nginx-kafka-manager' />

<@swarm.NETWORK_RM 'kafka-net' />
