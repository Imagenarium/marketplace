<@requirement.CONSTRAINT 'kafka' '1' />
<@requirement.CONSTRAINT 'kafka' '2' />
<@requirement.CONSTRAINT 'kafka' '3' />

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
