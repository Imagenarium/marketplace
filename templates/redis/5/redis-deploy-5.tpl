<#-- https://raw.githubusercontent.com/antirez/redis/4.0/redis.conf -->

<@requirement.CONSTRAINT 'redis' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify redis external port (for example 6379)' />
<@requirement.PARAM name='CMD' value='--appendonly yes --protected-mode no' />

<@swarm.SERVICE 'redis-${namespace}' 'imagenarium/redis:4.0' PARAMS.CMD>
  <@service.NETWORK 'redis-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '6379' />
  <@service.VOLUME '/data' />
  <@service.CONSTRAINT 'redis' 'true' />
</@swarm.SERVICE>

<@docker.CONTAINER 'redis-checker-${namespace}' 'imagenarium/redis:4.0'>
  <@container.NETWORK 'redis-net-${namespace}' />
  <@container.ENV 'REDIS_HOST' 'redis-${namespace}' />
  <@container.ENTRY '/checkdb.sh' />
  <@container.EPHEMERAL />
</@docker.CONTAINER>