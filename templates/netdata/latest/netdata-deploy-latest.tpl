<@requirement.NAMESPACE 'monitoring' />

<@requirement.PARAM name='PUBLISHED_PORT' value='19999' type='port' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='$apr1$WqbmakdQ$xqF8YxFcUHtO.X20fjgiJ1' />
          
<@swarm.TASK 'netdata-${namespace}'>
  <@container.PORT PARAMS.PUBLISHED_PORT '19999' />
  <@container.NETWORK 'netdata-net-${namespace}' />
  <@container.BIND '/etc/group' '/host/etc/group' />
  <@container.BIND '/proc' '/host/proc' />
  <@container.BIND '/sys' '/host/sys' />
  --security-opt apparmor=unconfined \
</@swarm.TASK>

<@swarm.TASK_RUNNER 'netdata-${namespace}' 'imagenarium/netdata:latest' '' 'global' />

<#--
<@swarm.SERVICE 'nginx-netdata-${namespace}' 'imagenarium/nginx-basic-auth:latest'>
  <@service.NETWORK 'netdata-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
  <@service.ENV 'WEB_USER' 'admin' />
  <@service.ENV 'WEB_PASSWORD' PARAMS.ADMIN_PASSWORD 'single' />
  <@service.ENV 'APP_URL' 'http://netdata-${namespace}-1:19999' />
</@swarm.SERVICE>
-->