<@requirement.CONSTRAINT 'logstash' 'true' />

<@requirement.PARAM name='LS_JAVA_OPTS' value='-Xms512m -Xmx512m -Dnetworkaddress.cache.ttl=10' />
<@requirement.PARAM name='PUBLISHED_PORT' value='' required='false' type='port' />

<@swarm.SERVICE 'logstash-${namespace}' 'imagenarium/logstash:6.6.0'>
  <@service.NETWORK 'es-net-${namespace}' />
  <@service.CONSTRAINT 'logstash' 'true' />
  <@service.PORT PARAMS.PUBLISHED_PORT '9600' />
  <@service.ENV 'ELASTICSEARCH_URL' 'http://es-router-${namespace}:9200' />
  <@service.ENV 'LS_JAVA_OPTS' PARAMS.LS_JAVA_OPTS />
  <@service.CHECK_PATH ':9600' />
</@swarm.SERVICE>