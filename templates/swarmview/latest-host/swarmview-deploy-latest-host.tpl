<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.TASK 'swarmview-${namespace}>
    <@container.HOST_NETWORK />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'swarmview-${namespace}' 'imagenarium/swarmview:0.1' '' 'global' />
</@requirement.CONFORMS>