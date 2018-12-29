<@requirement.CONSTRAINT 'couchdb' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' value='5984' type='port' />
<@requirement.PARAM name='USER' value='admin' />
<@requirement.PARAM name='PASSWORD' value='admin' type='password' />

<@swarm.SERVICE 'couchdb-${namespace}' 'imagenarium/couchdb:2.3'>
  <@service.NETWORK 'couchdb-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5984' />
  <@service.VOLUME '/opt/couchdb/data' />
  <@service.CONSTRAINT 'couchdb' 'true' />
  <@service.ENV 'COUCHDB_USER' PARAMS.USER />
  <@service.ENV 'COUCHDB_PASSWORD' PARAMS.PASSWORD />
  <@service.CHECK_PORT '5984' />
</@swarm.SERVICE>