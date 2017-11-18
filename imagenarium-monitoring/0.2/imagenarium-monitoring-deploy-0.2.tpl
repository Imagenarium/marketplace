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







<#!--
<@swarm.NETWORK 'haproxy-monitoring' />

<@swarm.SERVICE 'introspector' 'imagenarium/introspector:0.16' 'global'>
  <@service.NETWORK 'monitoring' />
  <@service.NETWORK 'haproxy-monitoring' />
  <@service.DOCKER_SOCKET />
</@swarm.SERVICE>

<@swarm.SERVICE 'dockergc' 'imagenarium/dockergc:0.2' 'global'>
  <@service.DOCKER_SOCKET />
  <@service.ENV 'CONTAINER_GRACE_PERIOD_MINUTES' '60' />
  <@service.ENV 'VOLUME_GRACE_PERIOD_MINUTES' '720' />
  <@service.ENV 'IMAGE_GRACE_PERIOD_MINUTES' '1440' />
</@swarm.SERVICE>

<@swarm.SERVICE 'drainpool' 'imagenarium/drainpool:0.1'>
  <@node.MANAGER />
  <@service.DOCKER_SOCKET />
</@swarm.SERVICE>
-->
