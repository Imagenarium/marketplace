<@requirement.CONS 'eclipse' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' value='7777' type='port' />
<@requirement.PARAM name='CHE_HOST' value='45.77.142.235' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'eclipse-${namespace}' 'eclipse/che-server:6.3.0'>
    <@service.VOLUME 'eclipse-volume-${namespace}' '/data' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'CHE_HOST' PARAMS.CHE_HOST />
    <@service.ENV 'CHE_DOCKER_IP_EXTERNAL' PARAMS.CHE_HOST />
    <@service.CONS 'node.labels.eclipse' 'true' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>
