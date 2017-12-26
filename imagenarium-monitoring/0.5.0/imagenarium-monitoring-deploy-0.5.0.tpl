<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'logdog-${dc}-${namespace}' 'imagenarium/logdog:0.5.0' 'global'>
      <@service.DOCKER_SOCKET />
      <@service.DC dc />
      <@service.NETWORK 'es-net-${namespace}' />
      <@service.ENV 'LOGSTASH_URL' 'logstash-${dc}-${namespace}:7778' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>

  <@swarm.SERVICE 'swarmview-${namespace}' 'imagenarium/swarmview:0.5.0' 'global'>
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'introspector' 'imagenarium/introspector:0.5.0' 'global'>
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
</@requirement.CONFORMS>