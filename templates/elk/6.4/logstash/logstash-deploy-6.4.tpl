<@requirement.CONS 'logstash' 'true' />

<@requirement.PARAM name='LS_JAVA_OPTS' value='-Xms512m -Xmx512m -Dnetworkaddress.cache.ttl=10' />

<@requirement.CONFORMS>
  <@swarm.TASK 'logstash-${namespace}'>
    <@container.NETWORK 'es-net-${namespace}' />
    <@container.ENV 'ELASTICSEARCH_URL' 'http://es-router-${namespace}-1:9200' />
    <@container.ENV 'LS_JAVA_OPTS' PARAMS.LS_JAVA_OPTS />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'logstash-${namespace}' 'imagenarium/logstash:6.4.0'>
    <@service.CONS 'node.labels.logstash' 'true' />
  </@swarm.TASK_RUNNER>

  <@docker.HTTP_CHECKER 'logstash-checker-${namespace}' 'http://logstash-${namespace}-1:9600' 'es-net-${namespace}' />
</@requirement.CONFORMS>
