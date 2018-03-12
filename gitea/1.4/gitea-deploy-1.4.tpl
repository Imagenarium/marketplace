<@requirement.NAMESPACE 'clustercontrol' />
<@requirement.CONS 'gitea' 'true' />
<@requirement.PARAM name='PUBLISHED_PORT' value='3000' type='port' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='gitea-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.SERVICE 'gitea-${namespace}' 'gitea/gitea:latest'>
    <@service.NETWORK 'clustercontrol-net' />
    <@service.PORT PARAMS.PUBLISHED_PORT '3000' />
    <@service.VOLUME 'gitea-volume-${namespace}' '/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECKER 'gitea-checker-${namespace}' 'http://gitea-${namespace}:3000' 'clustercontrol-net' />
</@requirement.CONFORMS>