<@requirement.PARAM name='PUBLISHED_PORT' type='port' value='19999' />
          
<@swarm.TASK 'netdata-${namespace}'>
  <@container.PORT PARAMS.PUBLISHED_PORT '19999' />
  <@container.VOLUME '/etc/group' '/etc/group' />
  <@container.VOLUME '/proc' '/host/proc' />
  <@container.VOLUME '/sys' '/host/sys' />
  --security-opt apparmor=unconfined \
</@swarm.TASK>

<@swarm.TASK_RUNNER 'netdata-${namespace}' 'imagenarium/netdata:latest' '' 'global' />