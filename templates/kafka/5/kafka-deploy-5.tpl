<@requirement.CONSTRAINT 'kafka' '1' />

<@requirement.PARAM name='GRAFANA_ADMIN_USER' value='admin' />
<@requirement.PARAM name='GRAFANA_ADMIN_PASSWORD' value='admin' />
<@requirement.PARAM name='GRAFANA_PUBLISHED_PORT' value='3000' type='port' />

<@swarm.SERVICE 'kafka-exporter-${namespace}' 'danielqsj/kafka-exporter' '--kafka.server=kafka-1-${namespace}:9092 --kafka.server=kafka-2-${namespace}:9092 --kafka.server=kafka-3-${namespace}:9092'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CHECK_PORT '9308' />
</@swarm.SERVICE>

<@swarm.SERVICE 'prometheus-${namespace}' 'imagenarium/prometheus-kafka:v2.5.0' '--storage.tsdb.retention=24h'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'kafka' '1' />
  <@service.CHECK_PORT '9090' />
</@swarm.SERVICE>

<@swarm.SERVICE 'grafana-${namespace}' 'imagenarium/grafana:5.4.0'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.GRAFANA_PUBLISHED_PORT '3000' />
  <@service.ANONYMOUS_VOLUME '/var/lib/grafana' />
  <@service.CONSTRAINT 'kafka' '1' />
  <@service.ENV 'GF_SECURITY_ADMIN_USER' PARAMS.GRAFANA_ADMIN_USER />
  <@service.ENV 'GF_SECURITY_ADMIN_PASSWORD' PARAMS.GRAFANA_ADMIN_PASSWORD />
  <@service.ENV 'GF_USERS_ALLOW_SIGN_UP' 'false' />
  <@service.CHECK_PORT '3000' />
</@swarm.SERVICE>