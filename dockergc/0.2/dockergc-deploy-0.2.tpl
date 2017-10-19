<@swarm.SERVICE 'dockergc' 'imagenarium/dockergc:0.2' 'global'>
  <@service.DOCKER_SOCKET />
  <@service.ENV 'CONTAINER_GRACE_PERIOD_MINUTES' '60' />
  <@service.ENV 'VOLUME_GRACE_PERIOD_MINUTES' '720' />
  <@service.ENV 'IMAGE_GRACE_PERIOD_MINUTES' '1440' />
</@swarm.SERVICE>
