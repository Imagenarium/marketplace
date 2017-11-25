<@requirement.PARAM 'uniqueId' 'system' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'logdog-${dc}-${uniqueId}' 'imagenarium/logdog:0.10' 'global'>
      <@service.DOCKER_SOCKET />
      <@service.DC dc />
      <@service.NETWORK 'es-net-${uniqueId}' />
      <@service.ENV 'LOGSTASH_URL' 'logstash-${dc}-${uniqueId}:7778' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>

  <@swarm.SERVICE 'swarmview-${uniqueId}' 'imagenarium/swarmview:0.9' 'global'>
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
</@requirement.CONFORMS>