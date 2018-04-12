<@requirement.CONS 'eclipse' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' value='7777' type='port' />
<@requirement.PARAM name='CHE_HOST' value='45.77.142.235' />

<@requirement.CONFORMS>
  <@swarm.TASK 'eclipse-${namespace}'>
    <@container.VOLUME 'eclipse-volume-${namespace}' '/data' />
    <@container.ENV 'CHE_HOST' PARAMS.CHE_HOST /> <#-- mandatory -->
    <@container.ENV 'CHE_DOCKER_IP_EXTERNAL' PARAMS.CHE_HOST /> <#-- for browser ws client -->
  </@swarm.TASK>

  <#-- works only if run as task (why? maybee --volumes-from prevents normal execution) -->
  <@swarm.TASK_RUNNER 'eclipse-${namespace}' 'eclipse/che-server:6.3.0'>
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' 'host' />
    <@service.ENV 'PROXY_PORTS' '8080' />
    <@service.CONS 'node.labels.eclipse' 'true' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>
