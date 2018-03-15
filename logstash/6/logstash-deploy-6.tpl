<@requirement.CONS 'logstash' 'true' />

<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' scope='global' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'logstash-${namespace}' 'imagenarium/logstash:6.2.2'>
    <@service.HOSTNAME 'logstash-${namespace}' />
    <@service.NETWORK 'es-net-${namespace}' />
    <@service.VOLUME 'logstash-volume-${namespace}' '/usr/share/logstash/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=1gb' />
    <@service.ENV 'ELASTICSEARCH_URL' 'http://es-router-${namespace}:9200' />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECKER 'logstash-checker-${namespace}' 'http://logstash-${namespace}:9600' 'es-net-${namespace}' />
</@requirement.CONFORMS>
