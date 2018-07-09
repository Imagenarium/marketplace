<@requirement.CONS 'logstash' 'true' />

<@requirement.PARAM name='LS_JAVA_OPTS' value='-Xms512m -Xmx512m -Dnetworkaddress.cache.ttl=10' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'logstash-${dc}-${namespace}' 'imagenarium/logstash:6.3.0'>
      <@service.HOSTNAME 'logstash-${dc}-${namespace}' />
      <@service.NETWORK 'es-net-${namespace}' />
      <@service.ENV 'ELASTICSEARCH_URL' 'http://es-master-${dc}-${namespace}:9200' />
      <@service.ENV 'LS_JAVA_OPTS' PARAMS.LS_JAVA_OPTS />
      <@service.DC dc />
    </@swarm.SERVICE>

    <@docker.HTTP_CHECKER 'logstash-checker-${namespace}' 'http://logstash-${dc}-${namespace}:9600' 'es-net-${namespace}' />
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
