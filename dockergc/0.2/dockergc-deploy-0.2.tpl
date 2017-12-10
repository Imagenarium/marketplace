<@requirement.PARAM name='CONTAINER_PERIOD' value='60' type='number' />
<@requirement.PARAM name='VOLUME_PERIOD' value='720' type='number' />
<@requirement.PARAM name='IMAGE_PERIOD' value='1440' type='number' />

<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'dockergc-${namespace}' 'imagenarium/dockergc:0.2' 'global'>
    <@service.DOCKER_SOCKET />
    <@service.ENV 'CONTAINER_GRACE_PERIOD_MINUTES' PARAMS.CONTAINER_PERIOD />
    <@service.ENV 'VOLUME_GRACE_PERIOD_MINUTES' PARAMS.VOLUME_PERIOD />
    <@service.ENV 'IMAGE_GRACE_PERIOD_MINUTES' PARAMS.IMAGE_PERIOD />
  </@swarm.SERVICE>
</@requirement.CONFORMS>