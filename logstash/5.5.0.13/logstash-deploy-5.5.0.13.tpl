<@swarm.NETWORK 'monitoring' />

<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE 'logstash-${dc}' 'imagenarium/logstash:5.5.0.13'>
    <@service.HOSTNAME 'logstash-${dc}' />
    <@service.DC dc />
    <@swarm.NETWORK 'monitoring' />
    <@service.ENV 'ELASTICSEARCH_URL' 'http://es-${dc}:9200' />
  </@swarm.SERVICE>
</@node.DATACENTER>

