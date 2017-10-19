<@requirement.PARAM 'dc' />
<@requirement.PARAM 'workerId' />

<#if params.dc?? && params.workerId??>
  <@requirement.CONS 'cassandra-worker' ${params.workerId} ${params.dc} />
</#if>

<@requirement.CONFORMS>
  <@bash.PROFILE>    
    <#assign seeds = [] />
    
    <@node.DATACENTER ; dc, index, isLast>
      <#assign seeds += ['cassandra-seed-${dc}'] />
    </@node.DATACENTER>
      
    <@swarm.SERVICE 'cassandra-worker-${params.dc}-${params.workerId}' 'imagenarium/cassandra:3.11.0'>
      <@service.NETWORK 'cassandra-net' />
      <@service.DNSRR />
      <@service.DC params.dc />
      <@service.DOCKER_SOCKET />
      <@service.CONS 'node.labels.cassandra-worker' '${params.workerId}' />
      <@service.VOLUME 'cassandra-worker-volume-${params.dc}-${params.workerId}' '/var/lib/cassandra' />
      <@service.ENV 'CASSANDRA_SEEDS' seeds?join(",") />
      <@service.ENV 'SERVICE_NAME' 'cassandra-worker-${params.dc}-${params.workerId}' />
      <@service.ENV 'CASSANDRA_DC' params.dc />
      <@service.ENV 'CASSANDRA_RACK' params.dc />
      <@service.ENV 'CASSANDRA_ENDPOINT_SNITCH' 'GossipingPropertyFileSnitch' />
    </@swarm.SERVICE>
  </@bash.PROFILE>
</@requirement.CONFORMS>
