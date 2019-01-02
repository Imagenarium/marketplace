<@requirement.NAMESPACE 'gitlab' />

<@requirement.CONSTRAINT 'gitlab' 'true' />

<@requirement.PARAM name='HOSTNAME' value='' />
<@requirement.PARAM name='PUBLISHED_PORT' value='8088' type='port' />
<@requirement.PARAM name='REGISTRY_PUBLISHED_PORT' value='5000' type='port' />

<@swarm.SERVICE 'gitlab-${namespace}' 'imagenarium/gitlab-ce'>
  <@service.CONSTRAINT 'gitlab' 'true' />
  <@service.NETWORK 'gitlab-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '80' 'host' />
  <@service.VOLUME '/var/opt/gitlab' />
  <@service.ENV 'GITLAB_OMNIBUS_CONFIG' "external_url 'http://${PARAMS.HOSTNAME}:${PARAMS.PUBLISHED_PORT}/'; registry_external_url 'http://${PARAMS.HOSTNAME}:${PARAMS.REGISTRY_PUBLISHED_PORT}/'" />
  <@service.CHECK_PORT '80' />
</@swarm.SERVICE>