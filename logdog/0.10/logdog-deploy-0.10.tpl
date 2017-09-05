<@swarm.NETWORK 'monitoring' />

<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE 'logdog-${dc}' 'imagenarium/logdog:0.10'>
    <@service.DOCKER_SOCKET />
    <@service.CONS 'dc' dc />
    <@swarm.NETWORK 'monitoring' />
    <@service.ENV 'LOGSTASH_URL' 'logstash-${dc}:7778' />
  </@swarm.SERVICE>
</@node.DATACENTER>

