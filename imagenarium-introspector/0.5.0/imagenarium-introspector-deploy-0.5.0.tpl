<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'introspector' 'imagenarium/introspector:0.5.0' 'global'>
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
</@requirement.CONFORMS>