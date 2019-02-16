<#-- https://raw.githubusercontent.com/antirez/redis/5.0/redis.conf -->

<@requirement.CONSTRAINT 'redis' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify redis external port (for example 6379)' />
<@requirement.PARAM name='CMD' value='--appendonly yes --protected-mode no' />

<@img.TASK 'redis-${namespace}' 'imagenarium/redis:5_1' PARAMS.CMD>
  <@img.NETWORK 'net-${namespace}' />
  <@img.PORT PARAMS.PUBLISHED_PORT '6379' />
  <@img.VOLUME '/data' />
  <@img.BIND '/sys/kernel/mm/transparent_hugepage' '/tph' />
  <@img.CONSTRAINT 'redis' 'true' />
  <@img.CHECK_PORT '6379' />
  <@img.ULIMIT 'nofile=65536:65536' />
  <@img.ULIMIT 'nproc=4096:4096' />
  <@img.ULIMIT 'memlock=-1:-1' />
</@img.TASK>
