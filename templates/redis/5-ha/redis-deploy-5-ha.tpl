<#-- https://raw.githubusercontent.com/antirez/redis/5.0/redis.conf -->

<@requirement.CONSTRAINT 'redis' '1' />
<@requirement.CONSTRAINT 'redis' '2' />
<@requirement.CONSTRAINT 'redis' '3' />

<@requirement.PARAM name='REDIS_PUBLISHED_PORT' type='port' required='false' description='Specify redis external port (for example 6379)' />
<@requirement.PARAM name='SENTINEL_PUBLISHED_PORT' type='port' value='26379' description='Specify sentinel external port (for example 26379)' />
<@requirement.PARAM name='CMD' value='' required='false' />

<#assign REDIS_VERSION='5-ha' />

<#list 1..3 as index>
  <@img.TASK 'redis-${index}-${namespace}' 'imagenarium/redis:${REDIS_VERSION}' PARAMS.CMD>
    <@img.NETWORK 'net-${namespace}' />
    <@img.PORT PARAMS.REDIS_PUBLISHED_PORT '6379' 'host' />
    <@img.VOLUME '/data' />
    <@img.BIND '/sys/kernel/mm/transparent_hugepage' '/tph' />
    <@img.CONSTRAINT 'redis' '${index}' />
    <@img.ULIMIT 'nofile=65536:65536' />
    <@img.ULIMIT 'nproc=4096:4096' />
    <@img.ULIMIT 'memlock=-1:-1' />
    <@img.ENV 'REDIS_PUBLISHED_PORT' PARAMS.REDIS_PUBLISHED_PORT />
    <@img.CHECK_PORT '6379' />
  </@img.TASK>
</#list>

<#list 1..3 as index>
  <@img.TASK 'redis-sentinel-${index}-${namespace}' 'imagenarium/redis:${REDIS_VERSION}' PARAMS.CMD>
    <@img.NETWORK 'net-${namespace}' />
    <@img.PORT PARAMS.SENTINEL_PUBLISHED_PORT '26379' 'host' />
    <@img.VOLUME '/data' />
    <@img.BIND '/sys/kernel/mm/transparent_hugepage' '/tph' />
    <@img.CONSTRAINT 'redis' '${index}' />
    <@img.ULIMIT 'nofile=65536:65536' />
    <@img.ULIMIT 'nproc=4096:4096' />
    <@img.ULIMIT 'memlock=-1:-1' />
    <@img.ENV 'SENTINEL_PUBLISHED_PORT' PARAMS.SENTINEL_PUBLISHED_PORT />
    <@img.ENV 'SENTINEL' 'true' />
    <@img.CHECK_PORT '26379' />
  </@img.TASK>
</#list>
