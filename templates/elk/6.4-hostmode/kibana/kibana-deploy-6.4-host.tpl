<@requirement.PARAM name='KIBANA_PASSWORD' value='$apr1$WqbmakdQ$xqF8YxFcUHtO.X20fjgiJ1' />

<@requirement.CONFORMS>
  <@swarm.TASK 'kibana-${namespace}'>
    <@service.ENV 'SERVER_NAME' 'kibana' />
    <@service.ENV 'ELASTICSEARCH_URL' 'http://es-router-${namespace}-1:9200' />
    <@service.ENV 'LOGGING_QUIET' 'true' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'kibana-${namespace}' 'imagenarium/kibana:6.4.1' />

  <@docker.HTTP_CHECKER 'kibana-checker-${namespace}' 'http://kibana-${namespace}-1:5601' />
</@requirement.CONFORMS>