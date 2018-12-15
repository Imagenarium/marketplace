<@requirement.CONSTRAINT 'kafka' '1' />
<@requirement.CONSTRAINT 'kafka' '2' />
<@requirement.CONSTRAINT 'kafka' '3' />

<@requirement.PARAM name='GRAFANA_ADMIN_USER' value='admin' />
<@requirement.PARAM name='GRAFANA_ADMIN_PASSWORD' value='admin' />
<@requirement.PARAM name='GRAFANA_PUBLISHED_PORT' value='3000' type='port' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='KAFKA_HEAP_OPTS' value='-Xmx1G -Xms1G' />

<#assign KAFKA_VERSION='5' />
  
<#assign zoo_connect = [] />
<#assign kafka_servers = [] />
  
<#list 1..3 as index>
  <#assign zoo_connect += ['zookeeper-${index}-${namespace}:2181'] />
  <#assign kafka_servers += ['kafka-${index}-${namespace}:9092'] />
</#list>
      
<#list 1..3 as index>
  <@swarm.SERVICE 'kafka-${index}-${namespace}' 'imagenarium/cp-kafka:${KAFKA_VERSION}'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '9092' 'host' />
    <@service.DNSRR />
    <@service.CONSTRAINT 'kafka' '${index}' />
    <@service.VOLUME '/var/lib/kafka/data' />
    <@service.ENV 'EXTERNAL_PORT' PARAMS.PUBLISHED_PORT! />
    <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
    <@service.ENV 'KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS' '10' />
    <@service.ENV 'KAFKA_BROKER_ID' '${index}' />
    <@service.ENV 'KAFKA_ZOOKEEPER_CONNECT' zoo_connect?join(",") />
    <@service.ENV 'KAFKA_MESSAGE_MAX_BYTES' '10485760' />
    <@service.ENV 'KAFKA_REPLICA_FETCH_MAX_BYTES' '10485760' />
    <@service.ENV 'KAFKA_AUTO_CREATE_TOPICS_ENABLE' 'false' />
    <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka-${index}-${namespace} -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.port=9999 -Djava.net.preferIPv4Stack=true' />
    <@service.ENV 'KAFKA_HEAP_OPTS' PARAMS.KAFKA_HEAP_OPTS />
    <@service.ENV 'KAFKA_MIN_INSYNC_REPLICAS' '2' />
    <@service.ENV 'KAFKA_DEFAULT_REPLICATION_FACTOR' '3' />
    <@service.ENV 'KAFKA_NUM_PARTITIONS' '128' />
  </@swarm.SERVICE>
</#list>

<@docker.CONTAINER 'kafka-checker-${namespace}' 'imagenarium/cp-kafka:${KAFKA_VERSION}'>
  <@container.ENTRY '/checker.sh' />
  <@container.NETWORK 'net-${namespace}' />
  <@container.EPHEMERAL />
  <@container.ENV 'ZOOKEEPER_CONNECT' zoo_connect?join(",") />
  <@container.ENV 'EXPECTED_BROKERS' '${kafka_servers?size}' />
</@docker.CONTAINER>

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