<@requirement.PARAM name='PUBLISHED_PORT' value='3333' type='port' />
<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'portainer-net-${namespace}' />

  <@swarm.SERVICE 'portainer-${namespace}' 'portainer/portainer:latest' 'replicated' '-H unix:///var/run/docker.sock'>
    <@node.MANAGER />
    <@service.PORT PARAMS.PUBLISHED_PORT '9000' />
  </@swarm.SERVICE>
  
  <@docker.HTTP_CHECKER 'portainer-checker-${namespace}' 'http://portainer-${namespace}:9000' 'portainer-net-${namespace}' />
</@requirement.CONFORMS>
