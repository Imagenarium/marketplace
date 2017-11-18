<@requirement.PARAM 'PORTAINER_PORT' '3333' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'portainer-${uniqueId}' 'portainer/portainer:latest' 'replicated' '-H unix:///var/run/docker.sock'>
    <@node.MANAGER />
    <@service.CONS 'node.labels.clustercontrol' 'true' />
    <@service.DOCKER_SOCKET />
    <@service.PORT PARAMS.PORTAINER_PORT '9000' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>
