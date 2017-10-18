<@requirement.HA />
<@requirement.CONS 'node.labels.db' 'cassandra' />

<@requirement.CONFORMS>
  <@bash.PROFILE>
    <@swarm.NETWORK 'cassandra-net' />
    
    <#assign seeds = [] />
    
    <@node.DATACENTER ; dc, index, isLast>
      <#assign seeds += ['cassandra-seed-${dc}'] />
    </@node.DATACENTER>
  
    <@swarm.SERVICE 'swarmstorage' 'imagenarium/swarmstorage:0.1'>
      <@service.NETWORK 'cassandra-net' />
      <@node.MANAGER />
      <@service.DOCKER_SOCKET />
    </@swarm.SERVICE>
    
    <@node.DATACENTER ; dc, index, isLast>
      <@swarm.SERVICE 'cassandra-seed-${dc}' 'imagenarium/cassandra:3.11.0' 'global'>
        <@service.NETWORK 'cassandra-net' />
        <@service.DNSRR />
        <@service.DC dc />
        <@service.DOCKER_SOCKET />
        <@service.CONS 'node.labels.db' 'cassandra' />
        <@service.VOLUME 'cassandra-seed-volume-${dc}' '/var/lib/cassandra' />
        <@service.ENV 'CASSANDRA_SEEDS' seeds?join(",") />
        <@service.ENV 'SERVICE_NAME' 'cassandra-seed-${dc}' />
        <@service.ENV 'CASSANDRA_DC' dc />
        <@service.ENV 'CASSANDRA_RACK' dc />
        <@service.ENV 'CASSANDRA_ENDPOINT_SNITCH' 'GossipingPropertyFileSnitch' />
      </@swarm.SERVICE>
    </@node.DATACENTER>
  </@bash.PROFILE>
</@requirement.CONFORMS>
