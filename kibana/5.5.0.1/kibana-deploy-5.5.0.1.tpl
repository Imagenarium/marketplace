<@requirement.SECRET 'kibana_manager_password' />

<@requirement.PARAM 'PUBLISHED_PORT' '5601' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'kibana-${uniqueId}' 'imagenarium/kibana:5.5.0.1'>
    <@service.NETWORK 'es-net-${uniqueId}' />
    <@service.ENV 'SERVER_NAME' 'kibana' />
    <@service.ENV 'ELASTICSEARCH_URL' 'http://es-router-${uniqueId}:9200' />
    <@service.ENV 'XPACK_MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED' 'false' />
    <@service.ENV 'XPACK_SECURITY_ENABLED' 'false' />
    <@service.ENV 'XPACK_GRAPH_ENABLED' 'false' />
    <@service.ENV 'XPACK_ML_ENABLED' 'false' />
    <@service.ENV 'XPACK_REPORTING_ENABLED' 'false' />
    <@service.ENV 'LOGGING_QUIET' 'true' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'nginx-kibana-${uniqueId}' 'imagenarium/nginx-basic-auth:1.13.5.1'>
    <@service.NETWORK 'es-net-${uniqueId}' />
    <@service.SECRET 'kibana_manager_password' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'WEB_USER' 'admin' />
    <@service.ENV 'WEB_PASSWORD_FILE' '/run/secrets/kibana_manager_password' />
    <@service.ENV 'APP_URL' 'http://kibana-${uniqueId}:5601' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>