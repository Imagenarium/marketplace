<@requirement.PARAM name='PUBLISHED_PORT' value='3333' type='port' />
<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'portainer-net-${namespace}' />

  <@swarm.SERVICE 'portainer-agent-${namespace}' 'portainer/agent:latest' '' 'global'>
    <@service.NETWORK 'portainer-net-${namespace}' />
    <@service.ENV 'AGENT_CLUSTER_ADDR' 'tasks.portainer-agent-${namespace}' />
    <@service.BIND '/var/lib/docker/volumes' '/var/lib/docker/volumes' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'portainer-${namespace}' 'portainer/portainer:latest' '-H tcp://tasks.portainer-agent-${namespace}:9001 --tlsskipverify'>
    <@node.MANAGER />
    <@service.NETWORK 'portainer-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '9000' />
  </@swarm.SERVICE>
  
  <@docker.HTTP_CHECKER 'portainer-checker-${namespace}' 'http://portainer-${namespace}:9000' 'portainer-net-${namespace}' />
</@requirement.CONFORMS>
