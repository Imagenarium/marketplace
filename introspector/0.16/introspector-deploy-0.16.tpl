<@swarm.NETWORK 'monitoring' />
<@swarm.NETWORK 'haproxy-monitoring' />

<@swarm.SERVICE 'introspector' 'imagenarium/introspector:0.16'>
  <@swarm.NETWORK 'monitoring' />
  <@swarm.NETWORK 'haproxy-monitoring' />
  <@service.DOCKER_SOCKET />
</@swarm.SERVICE>
