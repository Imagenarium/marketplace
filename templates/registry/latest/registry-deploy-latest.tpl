<@requirement.NAMESPACE 'clustercontrol' />

<@requirement.CONS 'registry' 'true' />

<@requirement.PARAM name='HTTP_HOST' value='https://docker.example.com' />
<@requirement.PARAM name='LETSENCRYPT_EMAIL' value='admin@example.com' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='REGISTRY_USER' value='admin' />
<@requirement.PARAM name='REGISTRY_PASSWORD' value='admin' type='password' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='registry-net-${namespace}' />

  <@swarm.STORAGE 'swarmstorage-registry-${namespace}' 'registry-net-${namespace}' />

  <@swarm.SERVICE 'registry-${namespace}' 'imagenarium/registry:latest'>
    <@service.CONS 'node.labels.registry' 'true' />
    <@service.NETWORK 'registry-net-${namespace}' />
    <@service.PORT '443' '5000' />
    <@service.VOLUME 'registry-volume-${namespace}' '/var/lib/registry' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, 1) />
    <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-registry-${namespace}' />
    <@service.ENV 'REGISTRY_USER' PARAMS.REGISTRY_USER />
    <@service.ENV 'REGISTRY_PASSWORD' PARAMS.REGISTRY_PASSWORD />
    <@service.ENV 'REGISTRY_HTTP_HOST' PARAMS.HTTP_HOST />
    <@service.ENV 'REGISTRY_HTTP_TLS_LETSENCRYPT_EMAIL' PARAMS.LETSENCRYPT_EMAIL />
  </@swarm.SERVICE>
</@requirement.CONFORMS>