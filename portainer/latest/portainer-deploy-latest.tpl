<@requirement.PARAM name='PUBLISHED_PORT' value='3333' type='port' />
<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'portainer-net-${namespace}' />

  <@swarm.SERVICE 'portainer-${namespace}' 'portainer/portainer:123latest' 'replicated' '-H unix:///var/run/docker.sock'>
    <@node.MANAGER />
    <@service.NETWORK 'portainer-net-${namespace}' />
    <@service.CONS 'node.labels.clustercontrol' 'true' />
    <@service.PORT PARAMS.PUBLISHED_PORT '9000' />
  </@swarm.SERVICE>
  
  <@docker.HTTP_CHECK 'http://portainer-${namespace}:9001' 'portainer-net-${namespace}' />
</@requirement.CONFORMS>
