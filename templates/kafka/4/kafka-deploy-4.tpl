<@requirement.CONS 'kafka' '1' />
<@requirement.CONS 'kafka' '2' />
<@requirement.CONS 'kafka' '3' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='PUBLISHED_REST_PORT' type='port' required='false' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='NETWORK_DRIVER' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />
<@requirement.PARAM name='ZOOKEEPER_HEAP_OPTS' value='-Xmx512M -Xms512M' />
<@requirement.PARAM name='KAFKA_HEAP_OPTS' value='-Xmx1G -Xms1G' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='kafka-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />
  
  <#assign zoo_servers = [] />
  <#assign zoo_connect = [] />
  <#assign kafka_servers = [] />
  
  <#list 1..3 as index>
    <#assign zoo_servers += ['server.${index}=zookeeper-${index}-${namespace}:2888:3888'] />
    <#assign zoo_connect += ['zookeeper-${index}-${namespace}:2181'] />
    <#assign kafka_servers += ['kafka-${index}-${namespace}:9092'] />
  </#list>

  <@swarm.STORAGE 'swarmstorage-kafka-${namespace}' 'kafka-net-${namespace}' />
  
  <#list 1..3 as index>
    <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
      <@swarm.VOLUME_RM 'zookeeper-volume-${index}-${namespace}' />
    </#if>

    <@swarm.SERVICE 'zookeeper-${index}-${namespace}' 'imagenarium/cp-zookeeper:4.1.1'>
      <@service.NETWORK 'kafka-net-${namespace}' />
      <@service.DNSRR />
      <@service.CONS 'node.labels.kafka' '${index}' />
      <@service.VOLUME 'zookeeper-volume-${index}-${namespace}' '/var/lib/zookeeper/data' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, 1) />
      <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@service.ENV 'VOLUME_DRIVER' PARAMS.VOLUME_DRIVER />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-kafka-${namespace}' />
      <@service.ENV 'ZOOKEEPER_SERVER_ID' '${index}' />
      <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=zookeeper-${index}-${namespace} -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.port=9999 -Djava.net.preferIPv4Stack=true' />
      <@service.ENV 'KAFKA_HEAP_OPTS' PARAMS.ZOOKEEPER_HEAP_OPTS />
      <@service.ENV 'ZOOKEEPER_SERVERS' zoo_servers?join(" ") />
    </@swarm.SERVICE>
  </#list>
    
  <#list 1..3 as index>
    <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
      <@swarm.VOLUME_RM 'kafka-volume-${index}-${namespace}' />
    </#if>

    <@swarm.SERVICE 'kafka-${index}-${namespace}' 'imagenarium/cp-kafka:4.1.1'>    
      <@service.NETWORK 'kafka-net-${namespace}' />
      <@service.PORT PARAMS.PUBLISHED_PORT '9092' 'host' />
      <@service.HOSTNAME 'kafka-${index}-${namespace}' />
      <@service.DNSRR />
      <@service.CONS 'node.labels.kafka' '${index}' />
      <@service.VOLUME 'kafka-volume-${index}-${namespace}' '/var/lib/kafka/data' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, PARAMS.VOLUME_SIZE_GB) />
      <@service.ENV 'EXTERNAL_PORT' PARAMS.PUBLISHED_PORT! />
      <@service.ENV 'NETWORK_NAME' 'kafka-net-${namespace}' />
      <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@service.ENV 'VOLUME_DRIVER' PARAMS.VOLUME_DRIVER />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-kafka-${namespace}' />
      <@service.ENV 'KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS' '10' />
      <@service.ENV 'KAFKA_BROKER_ID' '${index}' />
      <@service.ENV 'KAFKA_ZOOKEEPER_CONNECT' zoo_connect?join(",") />
      <@service.ENV 'KAFKA_MESSAGE_MAX_BYTES' '10485760' />
      <@service.ENV 'KAFKA_REPLICA_FETCH_MAX_BYTES' '10485760' />
      <@service.ENV 'KAFKA_AUTO_CREATE_TOPICS_ENABLE' 'false' />
      <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka-${index}-${namespace} -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.port=9999 -Djava.net.preferIPv4Stack=true' />
      <@service.ENV 'KAFKA_HEAP_OPTS' PARAMS.KAFKA_HEAP_OPTS />
      <@service.ENV 'KAFKA_DEFAULT_REPLICATION_FACTOR' '3' />
      <@service.ENV 'KAFKA_NUM_PARTITIONS' '128' />
    </@swarm.SERVICE>
  </#list>

  <@docker.CONTAINER 'kafka-checker-${namespace}' 'confluentinc/cp-base:4.1.1' 'cub kafka-ready -b ${kafka_servers?join(",")} -z ${zoo_connect?join(",")} ${kafka_servers?size} 120'>
    <@container.NETWORK 'kafka-net-${namespace}' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>

  <@swarm.SERVICE 'kafka-rest-${namespace}' 'confluentinc/cp-kafka-rest:4.1.1'>
    <@service.PORT PARAMS.PUBLISHED_REST_PORT '8082' />
    <@service.ENV 'KAFKA_REST_ZOOKEEPER_CONNECT' zoo_connect?join(",") />
    <@service.ENV 'KAFKA_REST_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka-rest-${namespace} -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.port=9999 -Djava.net.preferIPv4Stack=true' />
  </@swarm.SERVICE>

  <@docker.CONTAINER 'kafka-rest-checker-${namespace}' 'confluentinc/cp-base:4.1.1' 'cub sr-ready kafka-rest-${namespace} 8082 120'>
    <@container.NETWORK 'kafka-net-${namespace}' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</@requirement.CONFORMS>