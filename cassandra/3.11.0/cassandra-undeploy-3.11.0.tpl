<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'cassandra-seed-${dc}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'swarmstorage-cassandra-${namespace}' />

  <@swarm.NETWORK_RM 'cassandra-net-${namespace}' />
</@requirement.CONFORMS>
