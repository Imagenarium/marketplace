<@requirement.CONS 'gitlab' 'true' />
<@requirement.PARAM name='HTTP_PUBLISHED_PORT' value='8000' type='port' />
<@requirement.PARAM name='SSL_PUBLISHED_PORT' value='4443' type='port' />
<@requirement.PARAM name='SSH_PUBLISHED_PORT' value='2222' type='port' />
<@requirement.PARAM name='REGISTRY_PUBLISHED_PORT' value='4567' type='port' />
<@requirement.PARAM name='HOSTNAME' value='gitlab-clustercontrol' type='string' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' values='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />


<@requirement.CONFORMS>
  <@swarm.NETWORK name='gitlab-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.SERVICE 'gitlab-${namespace}' 'imagenarium/gitlab-ce:latest'>
    <@service.CONS 'node.labels.gitlab' 'true' />
    <@service.NETWORK 'gitlab-net-${namespace}' />
    <@service.PORT PARAMS.HTTP_PUBLISHED_PORT PARAMS.HTTP_PUBLISHED_PORT />
    <@service.PORT PARAMS.SSL_PUBLISHED_PORT PARAMS.SSL_PUBLISHED_PORT />
    <@service.PORT PARAMS.SSH_PUBLISHED_PORT PARAMS.SSH_PUBLISHED_PORT />
    <@service.PORT PARAMS.REGISTRY_PUBLISHED_PORT PARAMS.REGISTRY_PUBLISHED_PORT />
    <@service.VOLUME 'gitlab-volume-${namespace}' '/etc/gitlab' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
    <@service.VOLUME 'gitlab-volume-${namespace}' '/var/log/gitlab' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
    <@service.VOLUME 'gitlab-volume-${namespace}' '/var/opt/gitlab' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
    <@service.ENV 'GITLAB_OMNIBUS_CONFIG' "external_url 'http://${PARAMS.HOSTNAME}:${PARAMS.HTTP_PUBLISHED_PORT}/'; registry_external_url 'http://${PARAMS.HOSTNAME}:${PARAMS.REGISTRY_PUBLISHED_PORT}; redis['port'] = 6379; redis['bind'] = '0.0.0.0'; postgresql['listen_address'] = '0.0.0.0'; postgresql['port'] = 5432; postgresql['trust_auth_cidr_addresses'] = %w(127.0.0.1/24);gitlab_rails['redis_host'] = '127.0.0.1'; gitlab_rails['redis_port'] = 6379; gitlab_rails['db_adapter'] = 'postgresql'; gitlab_rails['db_encoding'] = 'utf8'; gitlab_rails['db_host'] = '127.0.0.1'; gitlab_rails['db_port'] = 5432 /'" />
  </@swarm.SERVICE>

</@requirement.CONFORMS>