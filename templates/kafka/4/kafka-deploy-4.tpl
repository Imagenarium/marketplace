<@requirement.CONS 'kafka' '1' />
<@requirement.CONS 'kafka' '2' />
<@requirement.CONS 'kafka' '3' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />
<@requirement.PARAM name='KAFKA_HEAP_OPTS' value='-Xmx1G -Xms1G' />
<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <#assign KAFKA_VERSION='4.1.2' />

  <@swarm.NETWORK name='net-${namespace}' driver=PARAMS.NETWORK_DRIVER />
  
  <#assign zoo_connect = [] />
  <#assign kafka_servers = [] />
  
  <#list 1..3 as index>
    <#assign zoo_connect += ['zookeeper-${index}-${namespace}:2181'] />
    <#assign kafka_servers += ['kafka-${index}-${namespace}:9092'] />
  </#list>

  <@swarm.STORAGE 'swarmstorage-kafka-${namespace}' 'net-${namespace}' />
      
  <#list 1..3 as index>
    <@swarm.SERVICE 'kafka-${index}-${namespace}' 'imagenarium/cp-kafka:${KAFKA_VERSION}'>
      <@service.NETWORK 'net-${namespace}' />
      <@service.PORT PARAMS.PUBLISHED_PORT '9092' 'host' />
      <@service.HOSTNAME 'kafka-${index}-${namespace}' />
      <@service.DNSRR />
      <@service.CONS 'node.labels.kafka' '${index}' />
      <@service.VOLUME 'kafka-volume-${index}-${namespace}' '/var/lib/kafka/data' />
      <@service.ENV 'EXTERNAL_PORT' PARAMS.PUBLISHED_PORT! />
      <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
      <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-kafka-${namespace}' />
      <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
      <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
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
</@requirement.CONFORMS>