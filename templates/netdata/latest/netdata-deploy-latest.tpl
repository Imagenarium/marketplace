<@requirement.NAMESPACE 'monitoring' />

<@requirement.PARAM name='PUBLISHED_PORT' value='19999' type='port' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='$apr1$WqbmakdQ$xqF8YxFcUHtO.X20fjgiJ1' />
          
<@img.TASK 'netdata-${namespace}' 'imagenarium/netdata:latest' '' 'global'>
  <@img.BIND '/etc/group' '/host/etc/group' />
  <@img.BIND '/proc' '/host/proc' />
  <@img.BIND '/sys' '/host/sys' />
  <@img.CUSTOM '--security-opt apparmor=unconfined' />
</@img.TASK>

<@img.TASK 'nginx-netdata-${namespace}' 'imagenarium/nginx-basic-auth:latest' '' 'global'>
  <@img.PORT PARAMS.PUBLISHED_PORT '8080' 'host' />
  <@img.ENV 'WEB_USER' 'admin' />
  <@img.ENV 'WEB_PASSWORD' PARAMS.ADMIN_PASSWORD 'single' />
  <@img.ENV 'APP_URL' 'http://netdata-${namespace}-{{.Node.ID}}:19999' />
</@img.TASK>
