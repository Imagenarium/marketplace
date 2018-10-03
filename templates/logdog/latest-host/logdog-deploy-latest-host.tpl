<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.TASK 'logdog-${namespace}'>
    <@container.HOST_NETWORK />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'logdog-${namespace}' 'imagenarium/logdog:0.1' '' 'global' />
</@requirement.CONFORMS>