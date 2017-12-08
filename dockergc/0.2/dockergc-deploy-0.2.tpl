<@requirement.PARAM name='CONTAINER_PERIOD' value='60' type='number' />
<@requirement.PARAM name='VOLUME_PERIOD' value='720' type='number' />
<@requirement.PARAM name='IMAGE_PERIOD' value='1440' type='number' />

<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'task-storage-net-${namespace}' />

  <@swarm.SERVICE 'task-storage-${namespace}' 'imagenarium/swarmstorage:0.1'>
    <@service.NETWORK 'task-storage-net-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'dockergc-${namespace}' 'imagenarium/dockergc:0.2' 'global'>
    <@service.DOCKER_SOCKET />
    <@service.NETWORK 'task-storage-net-${namespace}' />
    <@service.ENV 'CONTAINER_GRACE_PERIOD_MINUTES' PARAMS.CONTAINER_PERIOD />
    <@service.ENV 'VOLUME_GRACE_PERIOD_MINUTES' PARAMS.VOLUME_PERIOD />
    <@service.ENV 'IMAGE_GRACE_PERIOD_MINUTES' PARAMS.IMAGE_PERIOD />
  </@swarm.SERVICE>
</@requirement.CONFORMS>