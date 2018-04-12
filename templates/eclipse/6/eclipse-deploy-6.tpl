<@requirement.PARAM name='CHE_HOST' value='45.77.142.235' />
<@requirement.PARAM name='PUBLISHED_PORT' value='7777' type='port' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'eclipse-${namespace}' 'eclipse/che-server:6.3.0'>
    <@service.VOLUME 'eclipse-data-volume-${namespace}' '/data' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, PARAMS.VOLUME_SIZE_GB) />
    <@service.ENV 'CHE_HOST' PARAMS.CHE_HOST />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>
