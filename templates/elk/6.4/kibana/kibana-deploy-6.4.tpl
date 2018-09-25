<@requirement.PARAM name='PUBLISHED_PORT' value='5601' type='port' />
<@requirement.PARAM name='KIBANA_PASSWORD' value='$apr1$WqbmakdQ$xqF8YxFcUHtO.X20fjgiJ1' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'kibana-${namespace}' 'imagenarium/kibana:6.4.1'>
    <@service.NETWORK 'es-net-${namespace}' />
    <@service.ENV 'SERVER_NAME' 'kibana' />
    <@service.ENV 'ELASTICSEARCH_URL' 'http://es-router-${namespace}-1:9200' />
    <@service.ENV 'LOGGING_QUIET' 'true' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'nginx-kibana-${namespace}' 'imagenarium/nginx-basic-auth:latest'>
    <@service.NETWORK 'es-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'WEB_USER' 'admin' />
    <@service.ENV 'WEB_PASSWORD' PARAMS.KIBANA_PASSWORD 'single' />
    <@service.ENV 'APP_URL' 'http://kibana-${namespace}:5601' />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECKER 'kibana-checker-${namespace}' 'http://kibana-${namespace}:5601' 'es-net-${namespace}' />
</@requirement.CONFORMS>