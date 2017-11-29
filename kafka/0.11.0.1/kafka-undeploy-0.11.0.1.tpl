<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'kafka-${dc}-${uniqueId}' />
    <@swarm.SERVICE_RM 'zookeeper-${dc}-${uniqueId}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'swarmstorage-kafka-${uniqueId}' />
  <@swarm.SERVICE_RM 'kafka-manager-${uniqueId}' />
  <@swarm.SERVICE_RM 'nginx-kafka-manager-${uniqueId}' />
  
  <@swarm.NETWORK_RM 'kafka-net-${uniqueId}' />
</@requirement.CONFORMS>
