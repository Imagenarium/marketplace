<@requirement.CONS 'kafka' '1' />
<@requirement.CONS 'kafka' '2' />
<@requirement.CONS 'kafka' '3' />

<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />
<@requirement.PARAM name='KAFKA_HEAP_OPTS' value='-Xmx1G -Xms1G' />
<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <#assign KAFKA_VERSION='4.1.2_2' />
  
  <#assign zoo_connect = [] />
  <#assign kafka_servers = [] />
  
  <#list 1..3 as index>
    <#assign zoo_connect += ['zookeeper-${index}-${namespace}-1:2181'] />
    <#assign kafka_servers += ['kafka-${index}-${namespace}-1:9092'] />
  </#list>
      
  <#list 1..3 as index>
    <@swarm.TASK 'kafka-${index}-${namespace}'>
      <@container.HOST_NETWORK />
      <@container.VOLUME 'kafka-volume-${index}-${namespace}' '/var/lib/kafka/data' />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage' />
      <@container.ENV 'KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS' '10' />
      <@container.ENV 'KAFKA_BROKER_ID' '${index}' />
      <@container.ENV 'KAFKA_ZOOKEEPER_CONNECT' zoo_connect?join(",") />
      <@container.ENV 'KAFKA_MESSAGE_MAX_BYTES' '10485760' />
      <@container.ENV 'KAFKA_REPLICA_FETCH_MAX_BYTES' '10485760' />
      <@container.ENV 'KAFKA_AUTO_CREATE_TOPICS_ENABLE' 'false' />
      <@container.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka-${index}-${namespace}-1 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=9998 -Dcom.sun.management.jmxremote.port=9998 -Djava.net.preferIPv4Stack=true' />
      <@container.ENV 'KAFKA_HEAP_OPTS' PARAMS.KAFKA_HEAP_OPTS />
      <@container.ENV 'KAFKA_MIN_INSYNC_REPLICAS' '2' />
      <@container.ENV 'KAFKA_DEFAULT_REPLICATION_FACTOR' '3' />
      <@container.ENV 'KAFKA_NUM_PARTITIONS' '128' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'kafka-${index}-${namespace}' 'imagenarium/cp-kafka:${KAFKA_VERSION}'>
      <@service.CONS 'node.labels.kafka' '${index}' />
      <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
      <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
    </@swarm.TASK_RUNNER>
  </#list>

  <@docker.CONTAINER 'kafka-checker-${namespace}' 'imagenarium/cp-kafka:${KAFKA_VERSION}'>
    <@container.HOST_NETWORK />
    <@container.ENTRY '/checker.sh' />
    <@container.EPHEMERAL />
    <@container.ENV 'ZOOKEEPER_CONNECT' zoo_connect?join(",") />
    <@container.ENV 'EXPECTED_BROKERS' '${kafka_servers?size}' />
  </@docker.CONTAINER>
</@requirement.CONFORMS>