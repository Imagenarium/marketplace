<@requirement.PARAM 'ES_NETWORK' 'es-net-system' />
<@requirement.PARAM 'ES_UNIQUE_ID' 'system' />
<@requirement.PARAM 'uniqueId' 'system' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'logstash-${dc}-${uniqueId}' 'imagenarium/logstash:5.5.0.13'>
      <@service.HOSTNAME 'logstash-${dc}-${uniqueId}' />
      <@service.DC dc />
      <@service.NETWORK PARAMS.ES_NETWORK />
      <@service.ENV 'ELASTICSEARCH_URL' 'http://es-master-${dc}-${PARAMS.ES_UNIQUE_ID}:9200' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
