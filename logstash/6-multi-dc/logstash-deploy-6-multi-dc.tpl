<@requirement.CONS 'logstash' 'true' />

<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' scope='global' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'logstash-${index}-${namespace}' 'imagenarium/logstash:6.2.2'>
      <@service.HOSTNAME 'logstash-${index}-${namespace}' />
      <@service.NETWORK 'es-net-${namespace}' />
      <@service.VOLUME 'logstash-volume-${index}-${namespace}' '/usr/share/logstash/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=1gb' />
      <@service.ENV 'ELASTICSEARCH_URL' 'http://es-master-${index}-${namespace}:9200' />
      <@service.DC dc />
    </@swarm.SERVICE>

    <@docker.HTTP_CHECKER 'logstash-checker-${namespace}' 'http://logstash-${index}-${namespace}:9600' 'es-net-${namespace}' />
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
