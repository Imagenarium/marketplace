<@requirement.CONS 'logstash' 'true' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'logstash-${dc}-${namespace}' 'imagenarium/logstash:6.2.2'>
      <@service.HOSTNAME 'logstash-${dc}-${namespace}' />
      <@service.NETWORK 'es-net-${namespace}' />
      <@service.ENV 'ELASTICSEARCH_URL' 'http://es-master-${dc}-${namespace}:9200' />
      <@service.DC dc />
    </@swarm.SERVICE>

    <@docker.HTTP_CHECKER 'logstash-checker-${namespace}' 'http://logstash-${dc}-${namespace}:9600' 'es-net-${namespace}' />
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
