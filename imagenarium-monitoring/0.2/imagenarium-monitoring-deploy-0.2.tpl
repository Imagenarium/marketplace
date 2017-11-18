<@requirement.PARAM 'ES_NETWORK' 'es-net-system' />
<@requirement.PARAM 'LOGSTASH_UNIQUE_ID' 'system' />
<@requirement.PARAM 'uniqueId' 'system' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'logdog-${dc}-${uniqueId}' 'imagenarium/logdog:0.10' 'global'>
      <@service.DOCKER_SOCKET />
      <@service.DC dc />
      <@service.NETWORK PARAMS.ES_NETWORK />
      <@service.ENV 'LOGSTASH_URL' 'logstash-${dc}-${PARAMS.LOGSTASH_UNIQUE_ID}:7778' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>

  <@swarm.SERVICE 'swarmview-${uniqueId}' 'imagenarium/swarmview:0.9' 'global'>
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
</@requirement.CONFORMS>