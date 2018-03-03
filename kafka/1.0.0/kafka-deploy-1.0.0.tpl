<@requirement.CONS 'kafka' 'true' '3' />

<@requirement.PARAM name='PUBLISHED_MANAGER_PORT' value='7878' type='number' />
<@requirement.PARAM name='RUN_KAFKA_MANAGER' value='false' type='boolean' />
<@requirement.PARAM name='NEW_CLUSTER' value='true' type='boolean' />
<@requirement.PARAM name='KAFKA_MUTEX' value='11111' />
<@requirement.PARAM name='ZOOKEEPER_MUTEX' value='11112' />
<@requirement.PARAM name='KAFKA_MANAGER_PASSWORD' value='$apr1$WqbmakdQ$xqF8YxFcUHtO.X20fjgiJ1' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='ZOOKEEPER_DATA_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='ZOOKEEPER_DATALOG_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='KAFKA_VOLUME_OPTS' value=' ' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='kafka-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />
  
  <#assign zoo_servers = [] />
  <#assign zoo_connect = [] />
  
  <#list 1..3 as index>
    <#assign zoo_servers += ['server.${index}=zookeeper-${index}-${namespace}:2888:3888'] />
    <#assign zoo_connect += ['zookeeper-${index}-${namespace}:2181'] />
  </#list>

  <@swarm.STORAGE 'swarmstorage-kafka-${namespace}' 'kafka-net-${namespace}' />
  
  <#list 1..3 as index>
    <@swarm.SERVICE 'zookeeper-${index}-${namespace}' 'imagenarium/zookeeper:3.4.10'>
      <@service.PORT_MUTEX PARAMS.ZOOKEEPER_MUTEX />
      <@service.NETWORK 'kafka-net-${namespace}' />
      <@service.DNSRR />
      <@service.CONS 'node.labels.kafka' 'true' />
      <@service.VOLUME 'zookeeper-data-volume-${index}-${namespace}' '/data' PARAMS.VOLUME_DRIVER PARAMS.ZOOKEEPER_DATA_VOLUME_OPTS?trim />
      <@service.VOLUME 'zookeeper-datalog-volume-${index}-${namespace}' '/datalog' PARAMS.VOLUME_DRIVER PARAMS.ZOOKEEPER_DATALOG_VOLUME_OPTS?trim />
      <@service.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-kafka-${namespace}' />
      <@service.ENV 'ZOO_MY_ID' '${index}' />
      <@service.ENV 'JMXPORT' '9099' />
      <@service.ENV 'ZOO_SERVERS' zoo_servers?join(" ") />
    </@swarm.SERVICE>
  </#list>
  
  <@docker.CONTAINER 'zookeeper-checker-${namespace}' 'imagenarium/zookeeper:3.4.10'>
    <@container.ENTRY '/zookeeper_checker.sh' />
    <@container.NETWORK 'kafka-net-${namespace}' />
    <@container.EPHEMERAL />
    <@container.ENV 'ZOO_CONNECT' zoo_connect?join(",") />
    <@container.ENV 'EXPECTED_FOLLOWERS' '${zoo_connect?size - 1}' />
  </@docker.CONTAINER>
  
  <#list 1..3 as index>
    <@swarm.SERVICE 'kafka-${index}-${namespace}' 'imagenarium/kafka:1.0.0_1'>
      <@service.PORT_MUTEX PARAMS.KAFKA_MUTEX />
      <@service.NETWORK 'kafka-net-${namespace}' />
      <@service.HOSTNAME 'kafka-${index}-${namespace}' />
      <@service.DNSRR />
      <@service.CONS 'node.labels.kafka' 'true' />
      <@service.VOLUME 'kafka-volume-${index}-${namespace}' '/kafka' PARAMS.VOLUME_DRIVER PARAMS.KAFKA_VOLUME_OPTS?trim />
      <@service.ENV 'NETWORK_NAME' 'kafka-net-${namespace}' />
      <@service.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-kafka-${namespace}' />
      <@service.ENV 'KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS' '10' />
      <@service.ENV 'KAFKA_BROKER_ID' '${index}' />
      <@service.ENV 'KAFKA_ZOOKEEPER_CONNECT' zoo_connect?join(",") />
      <@service.ENV 'KAFKA_MESSAGE_MAX_BYTES' '10485760' />
      <@service.ENV 'KAFKA_REPLICA_FETCH_MAX_BYTES' '10485760' />
      <@service.ENV 'KAFKA_AUTO_CREATE_TOPICS_ENABLE' 'false' />
      <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka-${index}-${namespace} -Dcom.sun.management.jmxremote.rmi.port=9999 -Djava.net.preferIPv4Stack=true' />
      <@service.ENV 'JMX_PORT' '9999' />
      <@service.ENV 'KAFKA_LISTENER_SECURITY_PROTOCOL_MAP' 'CLIENT:PLAINTEXT,REPLICATION:PLAINTEXT' />
      <@service.ENV 'KAFKA_ADVERTISED_PROTOCOL_NAME' 'CLIENT' />
      <@service.ENV 'KAFKA_PROTOCOL_NAME' 'REPLICATION' />
      <@service.ENV 'KAFKA_ADVERTISED_PORT' '9092' />
      <@service.ENV 'KAFKA_PORT' '9093' />
    </@swarm.SERVICE>
  </#list>

  <@docker.CONTAINER 'kafka-checker-${namespace}' 'imagenarium/zookeeper:3.4.10'>
    <@container.ENTRY '/kafka_checker.sh' />
    <@container.NETWORK 'kafka-net-${namespace}' />
    <@container.EPHEMERAL />
    <@container.ENV 'ZOO_CONNECT' zoo_connect?join(",") />
    <@container.ENV 'EXPECTED_BROKERS' '${zoo_connect?size}' />
  </@docker.CONTAINER>

  <#if PARAMS.RUN_KAFKA_MANAGER == "true">
    <@swarm.SERVICE 'kafka-manager-${namespace}' 'imagenarium/kafka-manager:1.3.3.16'>
      <@service.NETWORK 'kafka-net-${namespace}' />
      <@service.ENV 'ZK_HOSTS' zoo_connect?join(",") />
    </@swarm.SERVICE>

    <@swarm.SERVICE 'nginx-kafka-manager-${namespace}' 'imagenarium/nginx-basic-auth:1.13.5.2'>
      <@service.NETWORK 'kafka-net-${namespace}' />
      <@service.PORT PARAMS.PUBLISHED_MANAGER_PORT '8080' />
      <@service.ENV 'WEB_USER' 'admin' />
      <@service.ENV 'WEB_PASSWORD' PARAMS.KAFKA_MANAGER_PASSWORD />
      <@service.ENV 'APP_URL' 'http://kafka-manager-${namespace}:9000' />
    </@swarm.SERVICE>

    <@docker.HTTP_CHECKER 'kafka-manager-checker-${namespace}' 'http://kafka-manager-${namespace}:9000' 'kafka-net-${namespace}' />
  </#if>  
</@requirement.CONFORMS>
