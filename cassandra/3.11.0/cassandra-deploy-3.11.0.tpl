<@requirement.HA />
<@requirement.CONS_HA 'cassandra' 'master' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />

<@requirement.CONFORMS>
  <#assign NETMASK=randomNetmask24 />
  <@swarm.NETWORK 'cassandra-net-${namespace}' '${NETMASK}.0/24' />
    
  <#assign seeds = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign seeds += ['cassandra-seed-${dc}-${namespace}'] />
  </@cloud.DATACENTER>
  
  <@swarm.SERVICE 'swarmstorage-cassandra-${namespace}' 'imagenarium/swarmstorage:0.5.0'>
    <@service.NETWORK 'cassandra-net-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'cassandra-seed-${dc}-${namespace}' 'imagenarium/cassandra:3.11.0'>
      <@service.NETWORK 'cassandra-net-${namespace}' />
      <@service.DNSRR />
      <@service.DC dc />
      <@service.DOCKER_SOCKET />
      <@service.CONS 'node.labels.cassandra' 'master' />
      <@service.VOLUME 'cassandra-seed-volume-${dc}-${namespace}' '/var/lib/cassandra' />
      <@service.ENV 'NETMASK' NETMASK />
      <@service.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-cassandra-${namespace}' />
      <@service.ENV 'CASSANDRA_SEEDS' seeds?join(",") />
      <@service.ENV 'SERVICE_NAME' 'cassandra-seed-${dc}-${namespace}' />
      <@service.ENV 'CASSANDRA_DC' dc />
      <@service.ENV 'CASSANDRA_RACK' dc />
      <@service.ENV 'CASSANDRA_ENDPOINT_SNITCH' 'GossipingPropertyFileSnitch' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>