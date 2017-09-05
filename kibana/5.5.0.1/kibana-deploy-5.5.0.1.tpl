<@bash.PROFILE>
  <@swarm.NETWORK 'monitoring' />

  <@swarm.SERVICE 'kibana' 'imagenarium/kibana:5.5.0.1'>
    <@service.NETWORK 'monitoring' />
    <@service.ENV 'SERVER_NAME' 'kibana' />
    <@service.ENV 'ELASTICSEARCH_URL' 'http://es-router:9200' />
    <@service.ENV 'XPACK_MONITORING_UI_CONTAINER_ELASTICSEARCH_ENABLED' 'false' />
    <@service.ENV 'XPACK_SECURITY_ENABLED' 'false' />
    <@service.ENV 'XPACK_GRAPH_ENABLED' 'false' />
    <@service.ENV 'XPACK_ML_ENABLED' 'false' />
    <@service.ENV 'XPACK_REPORTING_ENABLED' 'false' />
    <@service.ENV 'LOGGING_QUIET' 'true' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'nginx-kibana' 'imagenarium/nginx-basic-auth:1.13.1.4'>
    <@service.NETWORK 'monitoring' />
    <@service.PORT '5601' '8080' />
    <@service.ENV 'WEB_USER' 'man4j' />
    <@service.ENV 'WEB_PASSWORD' '$apr1$h9Xllpx6$bBVR6h5YDkCRJACM2wfgg/' />
    <@service.ENV 'APP_URL' 'http://kibana:5601' />
  </@swarm.SERVICE>
</@bash.PROFILE>