<#-- https://raw.githubusercontent.com/antirez/redis/4.0/redis.conf -->

<@requirement.CONS 'redis' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify redis external port (for example 6379)' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />
<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='redis-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-redis-${namespace}' 'redis-net-${namespace}' />

  <@swarm.SERVICE 'redis-${namespace}' 'imagenarium/redis:4.0' '--appendonly yes --protected-mode off'>
    <@service.NETWORK 'redis-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '6379' />
    <@service.VOLUME 'redis-volume-${namespace}' '/data' />
    <@service.CONS 'node.labels.redis' 'true' />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-redis-${namespace}' />
    <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
  </@swarm.SERVICE>

  <@docker.CONTAINER 'redis-checker-${namespace}' 'imagenarium/redis:4.0'>
    <@container.NETWORK 'redis-net-${namespace}' />
    <@container.ENV 'REDIS_HOST' 'redis-${namespace}' />
    <@container.ENTRY '/checkdb.sh' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</@requirement.CONFORMS>