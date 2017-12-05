<@requirement.NAMESPACE 'system' />
<@requirement.PARAM name='PUBLISHED_PORT' value='5601' type='number' />

<@requirement.SECRET 'kibana_manager_password' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'kibana-${namespace}' 'imagenarium/kibana:5.5.0.1'>
    <@service.NETWORK 'es-net-${namespace}' />
    <@service.ENV 'SERVER_NAME' 'kibana' />
    <@service.ENV 'ELASTICSEARCH_URL' 'http://es-router-${namespace}:9200' />
    <@service.ENV 'XPACK_MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED' 'false' />
    <@service.ENV 'XPACK_SECURITY_ENABLED' 'false' />
    <@service.ENV 'XPACK_GRAPH_ENABLED' 'false' />
    <@service.ENV 'XPACK_ML_ENABLED' 'false' />
    <@service.ENV 'XPACK_REPORTING_ENABLED' 'false' />
    <@service.ENV 'LOGGING_QUIET' 'true' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'nginx-kibana-${namespace}' 'imagenarium/nginx-basic-auth:1.13.5.1'>
    <@service.NETWORK 'es-net-${namespace}' />
    <@service.SECRET 'kibana_manager_password' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'WEB_USER' 'admin' />
    <@service.ENV 'WEB_PASSWORD_FILE' '/run/secrets/kibana_manager_password' />
    <@service.ENV 'APP_URL' 'http://kibana-${namespace}:5601' />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECK 'http://kibana-${namespace}:5601' 'es-net-${namespace}' />
</@requirement.CONFORMS>