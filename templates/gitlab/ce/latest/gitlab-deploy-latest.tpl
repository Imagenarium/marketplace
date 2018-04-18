<@requirement.NAMESPACE 'clustercontrol' />

<@requirement.CONS 'gitlab' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' value='8000' type='port' />
<@requirement.PARAM name='HTTP_HOST' value='http://docker.example.com' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='gitlab-net-${namespace}' />

  <@swarm.STORAGE 'swarmstorage-gitlab-${namespace}' 'gitlab-net-${namespace}' />

  <@swarm.SERVICE 'gitlab-${namespace}' 'imagenarium/gitlab-ce:rc'>
    <@service.CONS 'node.labels.gitlab' 'true' />
    <@service.NETWORK 'gitlab-net-${namespace}' />
    <@service.NETWORK 'clustercontrol-net' />
    <@service.PORT PARAMS.PUBLISHED_PORT PARAMS.PUBLISHED_PORT />
    <@service.VOLUME 'gitlab-volume-${namespace}' '/var/opt/gitlab' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, 1) />
    <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-gitlab-${namespace}' />
    <@service.ENV 'GITLAB_OMNIBUS_CONFIG' "external_url '${PARAMS.HTTP_HOST}:${PARAMS.PUBLISHED_PORT}/'" />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECKER 'gitlab-checker-${namespace}' '${PARAMS.HTTP_HOST}:${PARAMS.PUBLISHED_PORT}/explore' 'gitlab-net-${namespace}' />
</@requirement.CONFORMS>