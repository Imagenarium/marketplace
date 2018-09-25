<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'logdog-${namespace}' 'imagenarium/logdog:0.1' '' 'global'>
    <@service.NETWORK 'es-net-${namespace}' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>