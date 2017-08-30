<@bash.HEADER />

<@node.UNIQUE_VALUES 'dc' ; labelValue, index, isLast>
  <@swarm.SERVICE_RM 'kafka-${labelValue}' />
  <@swarm.SERVICE_RM 'zookeeper-${labelValue}' />
</@node.UNIQUE_VALUES>

<@swarm.NETWORK_RM 'kafka-net' />
