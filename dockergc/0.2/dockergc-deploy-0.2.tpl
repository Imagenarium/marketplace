<@requirement.PARAM 'CONTAINER_PERIOD' '60' />
<@requirement.PARAM 'VOLUME_PERIOD' '720' />
<@requirement.PARAM 'IMAGE_PERIOD' '1440' />
<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'dockergc-${namespace}' 'imagenarium/dockergc:0.2' 'global'>
    <@service.DOCKER_SOCKET />
    <@service.ENV 'CONTAINER_GRACE_PERIOD_MINUTES' PARAMS.CONTAINER_PERIOD />
    <@service.ENV 'VOLUME_GRACE_PERIOD_MINUTES' PARAMS.VOLUME_PERIOD />
    <@service.ENV 'IMAGE_GRACE_PERIOD_MINUTES' PARAMS.IMAGE_PERIOD />
  </@swarm.SERVICE>
</@requirement.CONFORMS>