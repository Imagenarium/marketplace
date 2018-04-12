<@requirement.CONS 'eclipse' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' value='7777' type='port' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'eclipse-${namespace}' 'eclipse/che-server:6.3.0'>
    <@service.VOLUME 'eclipse-volume-${namespace}' '/data' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.CONS 'node.labels.eclipse' 'true' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>
