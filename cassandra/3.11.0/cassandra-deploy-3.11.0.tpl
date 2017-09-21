<@bash.PROFILE>  
  <@swarm.NETWORK 'cassandra-net' />
  
  <#assign seeds = [] />
  
  <@node.DATACENTER ; dc, index, isLast>
    <#assign seeds += ['cassandra-${dc}'] />
  </@node.DATACENTER>
  
  <@node.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'cassandra-${dc}' 'imagenarium/cassandra:3.11.0'>
      <@service.NETWORK 'cassandra-net' />
      <@service.DNSRR />
      <@service.DC dc />
      <@service.ENV 'CASSANDRA_SEEDS' seeds?join(",") />
      <@service.ENV 'SERVICE_NAME' 'cassandra-${dc}' />
      <@service.ENV 'CASSANDRA_RACK' dc />
      <@service.ENV 'CASSANDRA_ENDPOINT_SNITCH' 'GossipingPropertyFileSnitch' />
    </@swarm.SERVICE>
  </@node.DATACENTER>
</@bash.PROFILE>