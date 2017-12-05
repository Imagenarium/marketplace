<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'logstash-${dc}-${namespace}' 'imagenarium/logstash:5.5.0.13'>
      <@service.HOSTNAME 'logstash-${dc}-${namespace}' />
      <@service.DC dc />
      <@service.NETWORK 'es-net-${namespace}' />
      <@service.ENV 'ELASTICSEARCH_URL' 'http://es-master-${dc}-${namespace}:9200' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
