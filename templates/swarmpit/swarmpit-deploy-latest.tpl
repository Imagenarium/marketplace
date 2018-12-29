<@requirement.CONSTRAINT 'swarmpit' 'true' />
<@requirement.PARAM name='PUBLISHED_PORT' value='3333' type='port' />
<@requirement.NAMESPACE 'system' />

<@swarm.SERVICE 'swarmpit-db-${namespace}' 'imagenarium/couchdb:2.3'>
  <@service.NETWORK 'swarmpit-net-${namespace}' />
  <@service.VOLUME '/opt/couchdb/data' />
  <@service.CONSTRAINT 'swarmpit' 'true' />
  <@service.CHECK_PORT '5984' />
</@swarm.SERVICE>

<@swarm.SERVICE 'swarmpit-agent-${namespace}' 'swarmpit/agent:latest' '' 'global'>
  <@service.NETWORK 'swarmpit-net-${namespace}' />
  <@service.CONSTRAINT 'swarmpit' 'true' />
  <@service.ENV 'DOCKER_API_VERSION' '1.35' />
</@swarm.SERVICE>

<@swarm.SERVICE 'swarmpit-${namespace}' 'swarmpit/swarmpit:latest'>
  <@node.MANAGER />
  <@service.NETWORK 'swarmpit-net-${namespace}' />
  <@service.CONSTRAINT 'swarmpit' 'true' />
  <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
  <@service.ENV 'SWARMPIT_DB' 'http://swarmpit-db-${namespace}:5984' />
  <@service.CHECK_PORT '8080' />
</@swarm.SERVICE>
  