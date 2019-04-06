<@requirement.CONSTRAINT 'memcached' 'true' />

<@requirement.PARAM name='MEMCACHED_PUBLISHED_PORT' type='port' required='false' description='Specify memcached external port (for example 11211)' />

<@swarm.SERVICE 'memcached-${namespace}' 'memcached:1.5-alpine' '-vv'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.DNSRR />
  <@service.CONSTRAINT 'memcached' 'true' />
  <@service.PORT PARAMS.MEMCACHED_PUBLISHED_PORT '11211' 'host' />
  <@service.CHECK_PORT '11211' />
</@swarm.SERVICE>
