<@requirement.CONS 'memcached' 'true' />

<@requirement.PARAM name='MEMCACHED_PORT' type='port' required='fase' description='Specify memcached external port (for example 11211)' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='memcached-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.SERVICE 'memcached-${namespace}' 'memcached:1.5-alpine' 'replicated' '-vv'>
    <@service.NETWORK 'memcached-net-${namespace}' />
    <@service.CONS 'node.labels.memcached' 'true' />
    <@service.PORT PARAMS.MEMCACHED_PORT '11211' />
  </@swarm.SERVICE>

  <@docker.CONTAINER 'memcached-checker-${namespace}' 'imagenarium/memcachedchecker:latest'>
    <@container.NETWORK 'memcached-net-${namespace}' />
    <@container.ENV 'HOST' 'memcached-${namespace}' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</@requirement.CONFORMS>