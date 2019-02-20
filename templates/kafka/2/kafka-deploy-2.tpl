<@requirement.CONSTRAINT 'kafka' '1' />
<@requirement.CONSTRAINT 'kafka' '2' />
<@requirement.CONSTRAINT 'kafka' '3' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='EXPORTER_PUBLISHED_PORT' type='port' value='9308' required='false' />
<@requirement.PARAM name='JMX_EXPORTER_PUBLISHED_PORT' type='port' value='7071' required='false' />
<@requirement.PARAM name='KAFKA_HEAP_OPTS' value='-Xmx1G -Xms1G' />

<#assign KAFKA_VERSION='2.1.0' />
  
<#assign zoo_connect = [] />
<#assign kafka_servers = [] />
<#assign kafka_exporter_servers = [] />
  
<#list 1..3 as index>
  <#assign zoo_connect += ['zookeeper-${index}-${namespace}:2181'] />
  <#assign kafka_servers += ['kafka-${index}-${namespace}:9092'] />
  <#assign kafka_exporter_servers += ['--kafka.server=kafka-${index}-${namespace}:9092'] />
</#list>
      
<#list 1..3 as index>
  <@swarm.SERVICE 'kafka-${index}-${namespace}' 'imagenarium/kafka:${KAFKA_VERSION}'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '9092' 'host' />
    <@service.PORT PARAMS.JMX_EXPORTER_PUBLISHED_PORT '7071' 'host' />
    <@service.DNSRR />
    <@service.CONSTRAINT 'kafka' '${index}' />
    <@service.VOLUME '/kafka' />
    <@service.ENV 'EXTERNAL_PORT' PARAMS.PUBLISHED_PORT! />

    <@service.ENV 'KAFKA_REPLICA_FETCH_MAX_BYTES' '10485760' />
    <@service.ENV 'KAFKA_MESSAGE_MAX_BYTES' '10485760' />
    <@service.ENV 'KAFKA_AUTO_CREATE_TOPICS_ENABLE' 'false' />
    <@service.ENV 'KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS' '10' />
    <@service.ENV 'KAFKA_BROKER_ID' '${index}' />
    <@service.ENV 'KAFKA_ZOOKEEPER_CONNECT' zoo_connect?join(",") />
    <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka-${index}-${namespace} -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.port=9999 -Djava.net.preferIPv4Stack=true' />
    <@service.ENV 'KAFKA_HEAP_OPTS' PARAMS.KAFKA_HEAP_OPTS />
    <@service.ENV 'KAFKA_MIN_INSYNC_REPLICAS' '2' />
    <@service.ENV 'KAFKA_DEFAULT_REPLICATION_FACTOR' '3' />
    <@service.ENV 'KAFKA_TRANSACTION_STATE_LOG_MIN_ISR' '2' />
    <@service.ENV 'KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR' '3' />
    <@service.ENV 'KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR' '3' />
    <@service.ENV 'KAFKA_CONFIG_STORAGE_REPLICATION_FACTOR' '3' />
  </@swarm.SERVICE>
</#list>

<@docker.CONTAINER 'kafka-checker-${namespace}' 'imagenarium/kafka:${KAFKA_VERSION}'>
  <@container.ENTRY '/checker.sh' />
  <@container.NETWORK 'net-${namespace}' />
  <@container.EPHEMERAL />
  <@container.ENV 'ZOOKEEPER_CONNECT' zoo_connect?join(",") />
  <@container.ENV 'EXPECTED_BROKERS' '${kafka_servers?size}' />
</@docker.CONTAINER>

<@swarm.SERVICE 'kafka-exporter-${namespace}' 'danielqsj/kafka-exporter:latest' kafka_exporter_servers?join(" ")>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.EXPORTER_PUBLISHED_PORT '9308' />
  <@service.ENV 'METRICS_ENDPOINT' '/metrics' />
  <@service.CONSTRAINT 'kafka' '1' />
  <@service.CHECK_PORT '9308' />
</@swarm.SERVICE>
