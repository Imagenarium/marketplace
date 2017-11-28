<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'cassandra-seed-${dc}-${uniqueId}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'swarmstorage-cassandra-${uniqueId}' />

  <@swarm.NETWORK_RM 'cassandra-net-${uniqueId}' />
</@requirement.CONFORMS>
