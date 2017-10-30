<@swarm.NETWORK 'monitoring' />

<@cloud.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE 'logdog-${dc}' 'imagenarium/logdog:0.10' 'global'>
    <@service.DOCKER_SOCKET />
    <@service.DC dc />
    <@service.NETWORK 'monitoring' />
    <@service.ENV 'LOGSTASH_URL' 'logstash-${dc}:7778' />
  </@swarm.SERVICE>
</@cloud.DATACENTER>

