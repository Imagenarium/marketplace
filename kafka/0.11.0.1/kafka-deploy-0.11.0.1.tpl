<@requirement.HA />
<@requirement.CONS 'kafka' 'true' />
<@requirement.SECRET 'kafka_manager_password' />

<@requirement.PARAM 'uniqueId' />
<@requirement.PARAM 'managerPort' '-1' />
<@requirement.PARAM 'brokerPort' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'kafka-net-${uniqueId}' />
  
  <#assign zoo_servers = [] />
  <#assign zoo_connect = [] />
  
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign zoo_servers += ['server.${index}=zookeeper-${dc}-${uniqueId}:2888:3888'] />
    <#assign zoo_connect += ['zookeeper-${dc}-${uniqueId}:2181'] />
  </@cloud.DATACENTER>

  <@swarm.SERVICE 'swarmstorage-kafka-${uniqueId}' 'imagenarium/swarmstorage:0.1'>
    <@service.NETWORK 'kafka-net-${uniqueId}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>
  
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'zookeeper-${dc}-${uniqueId}' 'imagenarium/zookeeper:3.4.10'>
      <@service.NETWORK 'kafka-net-${uniqueId}' />
      <@service.DOCKER_SOCKET />
      <@service.DNSRR />
      <@service.DC dc />
      <@service.CONS 'node.labels.kafka' 'true' />
      <@service.VOLUME 'zookeeper-data-volume-${uniqueId}' '/data' />
      <@service.VOLUME 'zookeeper-datalog-volume-${uniqueId}' '/datalog' />
      <@service.ENV 'SERVICE_NAME' 'zookeeper-${dc}-${uniqueId}' />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-kafka-${uniqueId}' />
      <@service.ENV 'ZOO_MY_ID' index />
      <@service.ENV 'JMXPORT' '9099' />
      <@service.ENV 'ZOO_SERVERS' zoo_servers?join(" ") />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
  
  <@docker.CONTAINER 'zookeeper-checker-${uniqueId}' 'imagenarium/zookeeper-checker:1.1'>
    <@container.NETWORK 'kafka-net-${uniqueId}' />
    <@container.EPHEMERAL />
    <@container.ENV 'ZOO_CONNECT' zoo_connect?join(",") />
    <@container.ENV 'EXPECTED_FOLLOWERS' zoo_connect?size - 1 />
  </@docker.CONTAINER>
  
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'kafka-${dc}-${uniqueId}' 'imagenarium/kafka:0.11.0.1'>
      <@service.NETWORK 'kafka-net-${uniqueId}' />
      <@service.PORT PARAMS.brokerPort '9092' 'host' />
      <@service.DOCKER_SOCKET />
      <@service.HOSTNAME 'kafka-${dc}-${uniqueId}' />
      <@service.DNSRR />
      <@service.DC dc />
      <@service.CONS 'node.labels.kafka' 'true' />
      <@service.VOLUME 'kafka-volume-${uniqueId}' '/kafka' />
      <@service.ENV 'SERVICE_NAME' 'kafka-${dc}-${uniqueId}' />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-kafka-${uniqueId}' />
      <@service.ENV 'KAFKA_LISTENERS' 'PLAINTEXT://0.0.0.0:9092' />
      <@service.ENV 'KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS' '10' />
      <@service.ENV 'KAFKA_BROKER_ID' index />
      <@service.ENV 'KAFKA_ZOOKEEPER_CONNECT' zoo_connect?join(",") />
      <@service.ENV 'KAFKA_MESSAGE_MAX_BYTES' '10485760' />
      <@service.ENV 'KAFKA_REPLICA_FETCH_MAX_BYTES' '10485760' />
      <@service.ENV 'KAFKA_AUTO_CREATE_TOPICS_ENABLE' 'false' />
      <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka-${dc}-${uniqueId} -Dcom.sun.management.jmxremote.rmi.port=9999 -Djava.net.preferIPv4Stack=true' />
      <@service.ENV 'JMX_PORT' '9999' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>

  <@docker.CONTAINER 'kafka-checker-${uniqueId}' 'imagenarium/kafka-checker:1.1'>
    <@container.NETWORK 'kafka-net-${uniqueId}' />
    <@container.EPHEMERAL />
    <@container.ENV 'ZOO_CONNECT' zoo_connect?join(",") />
    <@container.ENV 'EXPECTED_BROKERS' zoo_connect?size />
  </@docker.CONTAINER>

  <#if PARAMS.managerPort != '-1'>
    <@swarm.SERVICE 'kafka-manager-${uniqueId}' 'imagenarium/kafka-manager:1.3.3.14'>
      <@service.NETWORK 'kafka-net-${uniqueId}' />
      <@service.ENV 'ZK_HOSTS' zoo_connect?join(",") />
    </@swarm.SERVICE>

    <@swarm.SERVICE 'nginx-kafka-manager-${uniqueId}' 'imagenarium/nginx-basic-auth:1.13.5.1'>
      <@service.SECRET 'kafka_manager_password' />
      <@service.NETWORK 'kafka-net-${uniqueId}' />
      <@service.PORT PARAMS.managerPort '8080' />
      <@service.ENV 'WEB_USER' 'admin' />
      <@service.ENV 'WEB_PASSWORD_FILE' '/run/secrets/kafka_manager_password' />
      <@service.ENV 'APP_URL' 'http://kafka-manager-${uniqueId}:9000' />
    </@swarm.SERVICE>
  </#if>
</@requirement.CONFORMS>