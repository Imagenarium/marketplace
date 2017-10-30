<@swarm.NETWORK 'monitoring' />

<@cloud.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE 'logstash-${dc}' 'imagenarium/logstash:5.5.0.13'>
    <@service.HOSTNAME 'logstash-${dc}' />
    <@service.DC dc />
    <@service.NETWORK 'monitoring' />
    <@service.ENV 'ELASTICSEARCH_URL' 'http://es-master-${dc}:9200' />
  </@swarm.SERVICE>
</@cloud.DATACENTER>

