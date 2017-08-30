<@bash.HEADER />

<@bash.PROFILE>
  <#assign ZOOKEEPER_VERSION='3.4.10' />
  <#assign KAFKA_VERSION='0.11.0.0' />
  
  <@swarm.NETWORK 'kafka-net' />
  
  <#assign zoo_servers = [] />
  <#assign zoo_connect = [] />
  
  <@node.UNIQUE_VALUES 'dc' ; labelValue, index, isLast>
    <#assign zoo_servers += ['server.${index}=zookeeper-${labelValue}:2888:3888'] />
    <#assign zoo_connect += ['zookeeper-${labelValue}:2181'] />
  </@node.UNIQUE_VALUES>
  
  <@node.UNIQUE_VALUES 'dc' ; labelValue, index, isLast>
    <@swarm.SERVICE 'zookeeper-${labelValue}' 'zookeeper:${ZOOKEEPER_VERSION}'>
      <@service.NETWORK 'kafka-net' />
      <@service.DNSRR />
      <@service.CONS 'dc' '${labelValue}' />
      <@service.VOLUME 'zookeeper-data-volume-${labelValue}' '/data' />
      <@service.VOLUME 'zookeeper-datalog-volume-${labelValue}' '/datalog' />
      <@service.ENV 'ZOO_MY_ID' '${index}' />
      <@service.ENV 'JMXPORT' '9099' />
      <@service.ENV 'ZOO_SERVERS' '${zoo_servers?join(" ")}' />
    </@swarm.SERVICE>
  </@node.UNIQUE_VALUES>
  
  <@docker.CONTAINER 'zookeeper-checker' 'imagenarium/zookeeper-checker:1.0'>
    <@container.NETWORK 'kafka-net' />
    <@container.INTERACTIVELY />
    <@container.EPHEMERAL />
    <@container.ENV 'ZOO_CONNECT' '${zoo_connect?join(",")}' />
  </@docker.CONTAINER>
  
  <@node.UNIQUE_VALUES 'dc' ; labelValue, index, isLast>
    <@swarm.SERVICE 'kafka-${labelValue}' 'wurstmeister/kafka:${KAFKA_VERSION}'>
      <@service.NETWORK 'kafka-net' />
      <@service.DNSRR />
      <@service.CONS 'dc' '${labelValue}' />
      <@service.VOLUME 'kafka-volume-${labelValue}' '/kafka' />
      <@service.ENV 'KAFKA_LISTENERS' 'PLAINTEXT://0.0.0.0:9092' />
      <@service.ENV 'KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS' '10' />
      <@service.ENV 'KAFKA_BROKER_ID' '${index}' />
      <@service.ENV 'KAFKA_ZOOKEEPER_CONNECT' '${zoo_connect?join(",")}' />
      <@service.ENV 'KAFKA_MESSAGE_MAX_BYTES' '10485760' />
      <@service.ENV 'KAFKA_REPLICA_FETCH_MAX_BYTES' '10485760' />
    </@swarm.SERVICE>
  </@node.UNIQUE_VALUES>
</@bash.PROFILE>