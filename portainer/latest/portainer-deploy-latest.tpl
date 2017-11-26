<@requirement.PARAM 'PUBLISHED_PORT' '3333' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'portainer-net-${uniqueId}' />

  <@swarm.SERVICE 'portainer-${uniqueId}' 'portainer/portainer:latest' 'replicated' '-H unix:///var/run/docker.sock'>
    <@node.MANAGER />
    <@service.NETWORK 'portainer-net-${uniqueId}' />
    <@service.CONS 'node.labels.clustercontrol' 'true' />
    <@service.DOCKER_SOCKET />
    <@service.PORT PARAMS.PUBLISHED_PORT '9000' />
  </@swarm.SERVICE>
  
  <@docker.HTTP_CHECK 'http://portainer-${uniqueId}:9000' 'portainer-net-${uniqueId}' />
</@requirement.CONFORMS>
