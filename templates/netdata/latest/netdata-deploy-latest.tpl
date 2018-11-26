<@requirement.PARAM name='PUBLISHED_PORT' type='port' value='19999' />
          
<@swarm.TASK 'netdata-${namespace}'>
  <@container.NETWORK 'netdata-net-${namespace}' />
  <@container.PORT PARAMS.PUBLISHED_PORT '19999' />
  <@container.BIND '/etc/group' '/host/etc/group' />
  <@container.BIND '/proc' '/host/proc' />
  <@container.BIND '/sys' '/host/sys' />
  --security-opt apparmor=unconfined \
</@swarm.TASK>

<@swarm.TASK_RUNNER 'netdata-${namespace}' 'imagenarium/netdata:latest' '' 'global' />