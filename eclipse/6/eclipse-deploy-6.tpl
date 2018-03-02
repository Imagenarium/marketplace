<@requirement.NAMESPACE 'system' />

<@requirement.PARAM name='PUBLISHED_PORT' value='7777' type='port' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DATA_VOLUME_OPTS' value=' ' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'eclipse-${namespace}' 'eclipse/che-server:6.1.1'>
    <@service.VOLUME 'eclipse-data-volume-${namespace}' '/data' PARAMS.VOLUME_DRIVER PARAMS.DATA_VOLUME_OPTS?trim />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>
