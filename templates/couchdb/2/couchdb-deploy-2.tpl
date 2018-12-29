<@requirement.CONSTRAINT 'couchdb' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' value='5984' type='port' />

<@swarm.SERVICE 'couchdb-${namespace}' 'imagenarium/couchdb:2.3'>
  <@service.NETWORK 'couchdb-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5984' />
  <@service.VOLUME '/opt/couchdb/data' />
  <@service.CONSTRAINT 'couchdb' 'true' />
  <@service.CHECK_PORT '5984' />
</@swarm.SERVICE>