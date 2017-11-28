<@requirement.HA />
<@requirement.CONS 'cassandra' 'master' />
<@requirement.PARAM 'uniqueId' />
<@requirement.PARAM 'NEW_CLUSTER' />

<@requirement.CONFORMS>
  <#assign NETMASK=randomNetmask24 />
  <@swarm.NETWORK 'cassandra-net-${uniqueId}' '${NETMASK}.0/24' />
    
  <#assign seeds = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign seeds += ['cassandra-seed-${dc}-${uniqueId}'] />
  </@cloud.DATACENTER>
  
  <@swarm.SERVICE 'swarmstorage-cassandra-${uniqueId}' 'imagenarium/swarmstorage:0.1'>
    <@service.NETWORK 'cassandra-net-${uniqueId}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'cassandra-seed-${dc}-${uniqueId}' 'imagenarium/cassandra:3.11.0'>
      <@service.NETWORK 'cassandra-net-${uniqueId}' />
      <@service.DNSRR />
      <@service.DC dc />
      <@service.DOCKER_SOCKET />
      <@service.CONS 'node.labels.cassandra' 'master' />
      <@service.VOLUME 'cassandra-seed-volume-${dc}-${uniqueId}' '/var/lib/cassandra' />
      <@service.ENV 'NETMASK' NETMASK />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-cassandra-${uniqueId}' />
      <@service.ENV 'CASSANDRA_SEEDS' seeds?join(",") />
      <@service.ENV 'SERVICE_NAME' 'cassandra-seed-${dc}-${uniqueId}' />
      <@service.ENV 'CASSANDRA_DC' dc />
      <@service.ENV 'CASSANDRA_RACK' dc />
      <@service.ENV 'CASSANDRA_ENDPOINT_SNITCH' 'GossipingPropertyFileSnitch' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>