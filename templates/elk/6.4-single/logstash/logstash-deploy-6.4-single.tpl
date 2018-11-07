<@requirement.CONS 'es' 'true' />

<@requirement.PARAM name='LS_JAVA_OPTS' value='-Xms512m -Xmx512m -Dnetworkaddress.cache.ttl=10' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'logstash-${namespace}' 'imagenarium/logstash:6.4.0'>
    <@service.HOSTNAME 'logstash-${namespace}' />
    <@service.NETWORK 'es-net-${namespace}' />
    <@service.CONS 'node.labels.es' 'true' />
    <@service.ENV 'ELASTICSEARCH_URL' 'http://es-${namespace}-1:9200' />
    <@service.ENV 'NUMBER_OF_REPLICAS' '0' />
    <@service.ENV 'LS_JAVA_OPTS' PARAMS.LS_JAVA_OPTS />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECKER 'logstash-checker-${namespace}' 'http://logstash-${namespace}:9600' 'es-net-${namespace}' />
</@requirement.CONFORMS>
