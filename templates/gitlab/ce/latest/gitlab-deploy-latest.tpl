<@requirement.NAMESPACE 'clustercontrol' />

<@requirement.CONS 'gitlab' 'true' />

<@requirement.PARAM name='HTTP_PUBLISHED_PORT' value='8000' type='port' />
<@requirement.PARAM name='SSL_PUBLISHED_PORT' value='4443' type='port' />
<@requirement.PARAM name='SSH_PUBLISHED_PORT' value='2222' type='port' />
<@requirement.PARAM name='REGISTRY_PUBLISHED_PORT' value='4567' type='port' />
<@requirement.PARAM name='HOSTNAME' value='example.com' type='string' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='gitlab-net-${namespace}' />

  <@swarm.SERVICE 'gitlab-${namespace}' 'gitlab/gitlab-ce:latest'>
    <@service.CONS 'node.labels.gitlab' 'true' />
    <@service.NETWORK 'gitlab-net-${namespace}' />
    <@service.NETWORK 'clustercontrol-net' />
    <@service.PORT PARAMS.HTTP_PUBLISHED_PORT PARAMS.HTTP_PUBLISHED_PORT />
    <@service.PORT PARAMS.SSL_PUBLISHED_PORT PARAMS.SSL_PUBLISHED_PORT />
    <@service.PORT PARAMS.SSH_PUBLISHED_PORT PARAMS.SSH_PUBLISHED_PORT />
    <@service.PORT PARAMS.REGISTRY_PUBLISHED_PORT PARAMS.REGISTRY_PUBLISHED_PORT />
    <@service.VOLUME 'gitlab-volume-${namespace}' '/var/opt/gitlab' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, 1) />
    <@service.ENV 'GITLAB_OMNIBUS_CONFIG' "external_url 'http://${PARAMS.HOSTNAME}:${PARAMS.HTTP_PUBLISHED_PORT}/'; registry_external_url 'http://${PARAMS.HOSTNAME}:${PARAMS.REGISTRY_PUBLISHED_PORT}/'" />
  </@swarm.SERVICE>
</@requirement.CONFORMS>