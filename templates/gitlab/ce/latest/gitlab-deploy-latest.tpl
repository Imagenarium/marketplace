<@requirement.NAMESPACE 'clustercontrol' />

<@requirement.CONS 'gitlab' 'true' />

<@requirement.PARAM name='HOSTNAME' value='imagenarium.space' />
<@requirement.PARAM name='HTTPS_PUBLISHED_PORT' value='4443' type='port' />
<@requirement.PARAM name='REGISTRY_PUBLISHED_PORT' value='4567' type='port' />

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
    <@service.PORT PARAMS.HTTPS_PUBLISHED_PORT PARAMS.HTTPS_PUBLISHED_PORT />
    <@service.PORT PARAMS.REGISTRY_PUBLISHED_PORT PARAMS.REGISTRY_PUBLISHED_PORT />
    <@service.PORT '80' '80' /> <#-- for certbot -->
    <@service.VOLUME 'gitlab-volume-${namespace}' '/var/opt/gitlab' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, PARAMS.VOLUME_SIZE_GB) />
    <@service.VOLUME 'gitlab-etc-volume-${namespace}' '/etc/gitlab' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, 1) />
    <@service.ENV 'HOSTNAME' PARAMS.HOSTNAME />
    <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-gitlab-${namespace}' />
    <@service.ENV 'GITLAB_OMNIBUS_CONFIG' "external_url 'https://${PARAMS.HOSTNAME}:${PARAMS.HTTPS_PUBLISHED_PORT}/'; registry_external_url 'https://${PARAMS.HOSTNAME}:${PARAMS.REGISTRY_PUBLISHED_PORT}/'" />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECKER 'gitlab-checker-${namespace}' 'https://${PARAMS.HOSTNAME}:${PARAMS.HTTPS_PUBLISHED_PORT}/explore' 'gitlab-net-${namespace}' />
</@requirement.CONFORMS>