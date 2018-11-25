<@requirement.CONSTRAINT 'memcached' 'true' />

<@requirement.PARAM name='MEMCACHED_PORT' type='port' required='false' description='Specify memcached external port (for example 11211)' />

<@swarm.SERVICE 'memcached-${namespace}' 'memcached:1.5-alpine' '-vv'>
  <@service.NETWORK 'memcached-net-${namespace}' />
  <@service.CONSTRAINT 'memcached' 'true' />
  <@service.PORT PARAMS.MEMCACHED_PORT '11211' />
</@swarm.SERVICE>

<@docker.CONTAINER 'memcached-checker-${namespace}' 'imagenarium/memcachedchecker:latest'>
  <@container.NETWORK 'memcached-net-${namespace}' />
  <@container.ENV 'HOST' 'memcached-${namespace}' />
  <@container.EPHEMERAL />
</@docker.CONTAINER>
