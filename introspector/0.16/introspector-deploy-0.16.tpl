<@swarm.NETWORK 'monitoring' />
<@swarm.NETWORK 'haproxy-monitoring' />

<@swarm.SERVICE 'introspector' 'imagenarium/introspector:0.16' 'global'>
  <@service.NETWORK 'monitoring' />
  <@service.NETWORK 'haproxy-monitoring' />
  <@service.DOCKER_SOCKET />
</@swarm.SERVICE>
