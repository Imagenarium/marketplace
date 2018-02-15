<@requirement.CONS 'memcached' 'true' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='sylex-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.SERVICE 'memcached-${namespace}' 'memcached:1.5-alpine'>
    <@service.NETWORK 'sylex-net-${namespace}' />
    <@service.CONS 'node.labels.memcached' 'true' />
  </@swarm.SERVICE>

  <@docker.CONTAINER 'memcached-checker-${namespace}' 'imagenarium/memcachedchecker:latest'>
    <@container.NETWORK 'sylex-net-${namespace}' />
    <@container.ENV 'HOST' 'memcached-${namespace}' />
    <@container.ENTRY '/check.sh' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</@requirement.CONFORMS>