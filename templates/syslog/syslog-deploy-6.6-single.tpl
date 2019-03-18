<@requirement.CONSTRAINT 'es-single' 'true' />

<@requirement.PARAM name='LS_JAVA_OPTS' value='-Xms512m -Xmx512m -Dnetworkaddress.cache.ttl=10' />
<@requirement.PARAM name='PUBLISHED_PORT' value='' type='port' />

<@swarm.SERVICE 'logstash-${namespace}' 'imagenarium/logstash-syslog:6.6.0'>
  <@service.CONSTRAINT 'es-single' 'true' />
  --publish mode=ingress,published=${PARAMS.PUBLISHED_PORT},target=514,protocol=udp \
  <@service.ENV 'LS_JAVA_OPTS' PARAMS.LS_JAVA_OPTS />
  <@service.CHECK_PATH ':9600' />
</@swarm.SERVICE>