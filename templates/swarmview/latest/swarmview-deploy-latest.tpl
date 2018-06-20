<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'swarmview-${namespace}' 'imagenarium/swarmview:0.1' '' 'global'>
    <@service.NETWORK 'es-net-${namespace}' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>