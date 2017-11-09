<@requirement.PARAM 'stackId' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'kafka-${dc}-${stackId}' />
    <@swarm.SERVICE_RM 'zookeeper-${dc}-${stackId}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'swarmstorage-kafka-${stackId}' />
  <@swarm.SERVICE_RM 'kafka-manager-${stackId}' />
  <@swarm.SERVICE_RM 'nginx-kafka-manager-${stackId}' />

  <@swarm.NETWORK_RM 'kafka-net-${stackId}' />
</@requirement.CONFORMS>
