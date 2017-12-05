<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'kafka-${dc}-${namespace}' />
    <@swarm.SERVICE_RM 'zookeeper-${dc}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'swarmstorage-kafka-${namespace}' />
  <@swarm.SERVICE_RM 'kafka-manager-${namespace}' />
  <@swarm.SERVICE_RM 'nginx-kafka-manager-${namespace}' />
  
  <@swarm.NETWORK_RM 'kafka-net-${namespace}' />
</@requirement.CONFORMS>
