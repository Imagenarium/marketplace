<@requirement.NAMESPACE 'system' />

<@requirement.PARAM name='PUBLISHED_PORT' value='7777' type='port' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DATA_VOLUME_OPTS' value=' ' />

<@requirement.CONFORMS>
  <@swarm.TASK 'eclipse-${namespace}'>
    <@service.VOLUME 'eclipse-data-volume-${namespace}' '/data' PARAMS.VOLUME_DRIVER PARAMS.DATA_VOLUME_OPTS?trim />
    <@service.ENV 'CHE_HOST' '45.77.142.235' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'eclipse-${namespace}' 'eclipse/che-server:6.1.1'>
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'PROXY_PORTS' '8080' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>
