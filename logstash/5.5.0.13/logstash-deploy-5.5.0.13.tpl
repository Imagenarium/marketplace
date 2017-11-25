<@requirement.PARAM 'uniqueId' 'system' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'logstash-${dc}-${uniqueId}' 'imagenarium/logstash:5.5.0.13'>
      <@service.HOSTNAME 'logstash-${dc}-${uniqueId}' />
      <@service.DC dc />
      <@service.NETWORK 'es-net-${uniqueId}' />
      <@service.ENV 'ELASTICSEARCH_URL' 'http://es-master-${dc}-${uniqueId}:9200' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
