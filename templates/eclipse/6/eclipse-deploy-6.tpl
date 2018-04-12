<@requirement.CONS 'eclipse' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' value='7777' type='port' />
<@requirement.PARAM name='CHE_HOST' value='45.77.142.235' />

<@requirement.CONFORMS>
  <@swarm.TASK 'eclipse-${namespace}'>
    <@container.VOLUME 'eclipse-volume-${namespace}' '/data' />
    <@container.ENV 'CHE_HOST' PARAMS.CHE_HOST />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'eclipse-${namespace}' 'eclipse/che-server:6.3.0'>
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'PROXY_PORTS' '8080' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>
