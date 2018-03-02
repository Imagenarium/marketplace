<@requirement.NAMESPACE 'system' />
<@requirement.CONS 'eclipse' 'true' />

<@requirement.PARAM name='CHE_IP' value='45.77.142.235' />
<@requirement.PARAM name='PUBLISHED_PORT' value='7777' type='port' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DATA_VOLUME_OPTS' value=' ' />

<@requirement.CONFORMS>
  <@swarm.TASK 'eclipse-${namespace}'>
    <@container.VOLUME 'eclipse-data-volume-${namespace}' '/data' PARAMS.VOLUME_DRIVER PARAMS.DATA_VOLUME_OPTS?trim />
    <@container.ENV 'CHE_HOST' PARAMS.CHE_IP />
    <@container.ENV 'CHE_DOCKER_IP_EXTERNAL' PARAMS.CHE_IP />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'eclipse-${namespace}' 'eclipse/che-server:6.1.1'>
    <@service.CONS 'node.labels.eclipse' 'true' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'PROXY_PORTS' '8080' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>
