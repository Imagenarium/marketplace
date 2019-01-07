<@requirement.NAMESPACE 'monitoring' />

<@requirement.PARAM name='PUBLISHED_PORT' value='19999' type='port' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='$apr1$WqbmakdQ$xqF8YxFcUHtO.X20fjgiJ1' />
          
<@img.TASK 'netdata-${namespace}' 'imagenarium/netdata:latest' '' 'global'>
  <@img.BIND '/etc/group' '/host/etc/group' />
  <@img.BIND '/proc' '/host/proc' />
  <@img.BIND '/sys' '/host/sys' />
  <@img.PORT PARAMS.PUBLISHED_PORT '19999' 'host' />
  <@img.CUSTOM '--security-opt apparmor=unconfined' />
</@img.TASK>
