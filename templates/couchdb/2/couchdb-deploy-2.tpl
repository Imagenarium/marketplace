<@requirement.CONSTRAINT 'couchdb' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' required='false' value='5984' type='port' />

<@swarm.SERVICE 'couchdb-${namespace}' 'imagenarium/couchdb:2.3'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5984' />
  <@service.VOLUME '/opt/couchdb/data' />
  <@service.CONSTRAINT 'couchdb' 'true' />
  <@service.CHECK_PORT '5984' />

  <@service.LABEL 'traefik.port' '5984' />
  <@service.LABEL 'traefik.frontend.entryPoints' 'http' />
  <@service.LABEL 'traefik.frontend.rule' 'PathPrefix:/' />
  <@service.LABEL 'traefik.docker.network' 'net-${namespace}' />
  <@service.LABEL 'traefik.backend.loadbalancer.stickiness' 'true' />
  <@service.LABEL 'traefik.backend.loadbalancer.method' 'drr' />
  <@service.LABEL 'traefik.backend.buffering.maxRequestBodyBytes' '10485760' />
  <@service.LABEL 'traefik.backend.buffering.maxResponseBodyBytes' '10485760' />
  <@service.LABEL 'traefik.backend.buffering.memRequestBodyBytes' '2097152' />
  <@service.LABEL 'traefik.backend.buffering.memResponseBodyBytes' '2097152' />
  <@service.LABEL 'traefik.backend.healthcheck.path' '/_utils' />
  <@service.LABEL 'traefik.backend.healthcheck.interval' '5s' />
  <@service.LABEL 'traefik.tags' namespace />
</@swarm.SERVICE>