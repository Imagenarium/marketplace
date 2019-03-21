<@requirement.CONSTRAINT 'es-single' 'true' />

<@requirement.PARAM name='LS_JAVA_OPTS' value='-Xms512m -Xmx512m -Dnetworkaddress.cache.ttl=10' />
<@requirement.PARAM name='PUBLISHED_PORT' value='' required='false' type='port' />
<@requirement.PARAM name='SYSLOG_PUBLISHED_PORT' value='' required='false' type='port' />

<@swarm.SERVICE 'logstash-${namespace}' 'imagenarium/logstash:6.6.0'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'es-single' 'true' />
  <@service.PORT PARAMS.PUBLISHED_PORT '4560' />
  <#if PARAMS.SYSLOG_PUBLISHED_PORT?has_content>
  --publish mode=ingress,published=${PARAMS.SYSLOG_PUBLISHED_PORT},target=514,protocol=udp \
  </#if>
  <@service.ENV 'ELASTICSEARCH_URL' 'http://es-${namespace}:9200' />
  <@service.ENV 'NUMBER_OF_REPLICAS' '0' />
  <@service.ENV 'LS_JAVA_OPTS' PARAMS.LS_JAVA_OPTS />
  <@service.CHECK_PORT '4560' />
</@swarm.SERVICE>