<@requirement.CONSTRAINT 'logstash' 'true' />

<@requirement.PARAM name='LS_JAVA_OPTS' value='-Xms512m -Xmx512m -Dnetworkaddress.cache.ttl=10' />
<@requirement.PARAM name='LS_PUBLISHED_PORT' value='' required='false' type='port' />
<@requirement.PARAM name='SYSLOG_PUBLISHED_PORT' value='' required='false' type='port' />
<@requirement.PARAM name='ES_HA' value='true' required='true,false' type='boolean' />

<@swarm.SERVICE 'logstash-${namespace}' 'imagenarium/logstash:6.6.0'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.DNSRR />
  <@service.CONSTRAINT 'logstash' 'true' />
  <@service.PORT PARAMS.LS_PUBLISHED_PORT '4560' />
  <@service.PORT PARAMS.SYSLOG_PUBLISHED_PORT '514' 'ingress' 'udp' />
  <@service.ENV 'ELASTICSEARCH_URL' 'http://es-${namespace}:9200' />

  <#if PARAMS.ES_HA == "false">  
    <@service.ENV 'NUMBER_OF_REPLICAS' '0' />
  </#if>

  <@service.ENV 'LS_JAVA_OPTS' PARAMS.LS_JAVA_OPTS />
  <@service.CHECK_PORT '4560' />
</@swarm.SERVICE>