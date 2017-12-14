<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>  
  <@swarm.TASK 'glusterfs-volume-${namespace}' 'imagenarium/glusterfs-volume:3.13u1'>
    <@container.NETWORK 'glusterfs-net-${namespace}' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'glusterfs-volume-${namespace}' 'global' />
</@requirement.CONFORMS>