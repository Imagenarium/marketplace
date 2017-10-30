<@requirement.PARAM 'dc' />
<@requirement.PARAM 'workerId' />

<#if requirement.p.dc?? && requirement.p.workerId??>
  <@requirement.CONS 'cassandra' requirement.p.workerId requirement.p.dc />
</#if>

<@requirement.CONFORMS>
  <@bash.PROFILE>    
    <#assign seeds = [] />
    
    <@cloud.DATACENTER ; dc, index, isLast>
      <#assign seeds += ['cassandra-seed-${dc}'] />
    </@cloud.DATACENTER>
      
    <@swarm.SERVICE 'cassandra-worker-${requirement.p.dc}-${requirement.p.workerId}' 'imagenarium/cassandra:3.11.0'>
      <@service.NETWORK 'cassandra-net' />
      <@service.DNSRR />
      <@service.DC requirement.p.dc />
      <@service.DOCKER_SOCKET />
      <@service.CONS 'node.labels.cassandra' requirement.p.workerId />
      <@service.VOLUME 'cassandra-worker-volume-${requirement.p.dc}-${requirement.p.workerId}' '/var/lib/cassandra' />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-cassandra' />
      <@service.ENV 'CASSANDRA_SEEDS' seeds?join(",") />
      <@service.ENV 'SERVICE_NAME' 'cassandra-worker-${requirement.p.dc}-${requirement.p.workerId}' />
      <@service.ENV 'CASSANDRA_DC' requirement.p.dc />
      <@service.ENV 'CASSANDRA_RACK' requirement.p.dc />
      <@service.ENV 'CASSANDRA_ENDPOINT_SNITCH' 'GossipingPropertyFileSnitch' />
    </@swarm.SERVICE>
  </@bash.PROFILE>
</@requirement.CONFORMS>
