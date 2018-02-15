<@requirement.CONS 'worker' 'true' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='sylex-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />  
  <@swarm.NETWORK name='multicast-net-${namespace}' driver='weave:latest' />
            
  <@swarm.TASK 'worker-${namespace}'>
    <@container.NETWORK 'sylex-net-${namespace}' />
    <@container.NETWORK 'multicast-net-${namespace}' />
    <@container.ENV 'SYLEX_NET' 'sylex-net-${namespace}' />
    <@container.ENV 'MULTICAST_NET' 'multicast-net-${namespace}' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'worker-${namespace}' 'imagenarium/sylex:0.1'>
    <@service.NETWORK 'sylex-net-${namespace}' />
    <@service.CONS 'node.labels.worker' 'true' />
    <@service.ENV 'PROXY_PORTS' '9099' />
  </@swarm.TASK_RUNNER>
</@requirement.CONFORMS>