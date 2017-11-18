<@requirement.SECRET 'kibana_manager_password' />

<@requirement.PARAM 'KIBANA_PORT' '5601' />
<@requirement.PARAM 'ES_NETWORK' 'es-net-system' />
<@requirement.PARAM 'ES_ROUTER' 'http://es-router-system:9200' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'kibana-${uniqueId}' 'imagenarium/kibana:5.5.0.1'>
    <@service.NETWORK PARAMS.ES_NETWORK />
    <@service.ENV 'SERVER_NAME' 'kibana' />
    <@service.ENV 'ELASTICSEARCH_URL' PARAMS.ES_ROUTER />
    <@service.ENV 'XPACK_MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED' 'false' />
    <@service.ENV 'XPACK_SECURITY_ENABLED' 'false' />
    <@service.ENV 'XPACK_GRAPH_ENABLED' 'false' />
    <@service.ENV 'XPACK_ML_ENABLED' 'false' />
    <@service.ENV 'XPACK_REPORTING_ENABLED' 'false' />
    <@service.ENV 'LOGGING_QUIET' 'true' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'nginx-kibana-${uniqueId}' 'imagenarium/nginx-basic-auth:1.13.5.1'>
    <@service.NETWORK PARAMS.ES_NETWORK />
    <@service.SECRET 'kibana_manager_password' />
    <@service.PORT PARAMS.KIBANA_PORT '8080' />
    <@service.ENV 'WEB_USER' 'admin' />
    <@service.ENV 'WEB_PASSWORD_FILE' '/run/secrets/kibana_manager_password' />
    <@service.ENV 'APP_URL' 'http://kibana-${uniqueId}:5601' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>