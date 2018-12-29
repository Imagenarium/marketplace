<@requirement.CONSTRAINT 'swarmpit' 'true' />
<@requirement.PARAM name='PUBLISHED_PORT' value='3333' type='port' />
<@requirement.NAMESPACE 'system' />

<@swarm.SERVICE 'swarmpit-db-${namespace}' 'klaemo/couchdb:2.0.0' />
  <@service.NETWORK 'swarmpit-net-${namespace}' />
  <@service.VOLUME '/opt/couchdb/data' />
  <@service.CONSTRAINT 'swarmpit' 'true' />
  <@service.ENV 'AGENT_CLUSTER_ADDR' 'tasks.portainer-agent-${namespace}' />
</@swarm.SERVICE>

<@swarm.SERVICE 'swarmpit-agent-${namespace}' 'swarmpit/agent:latest' '' 'global' />
  <@service.NETWORK 'swarmpit-net-${namespace}' />
  <@service.CONSTRAINT 'swarmpit' 'true' />
  <@service.ENV 'DOCKER_API_VERSION' '1.35' />
</@swarm.SERVICE>

<@swarm.SERVICE 'swarmpit-${namespace}' 'swarmpit/swarmpit:latest'>
  <@node.MANAGER />
  <@service.NETWORK 'swarmpit-net-${namespace}' />
  <@service.CONSTRAINT 'swarmpit' 'true' />
  <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
  <@service.ENV 'SWARMPIT_DB' 'http://db:5984' />
  <@service.CHECK_PORT '8080' />
</@swarm.SERVICE>
  