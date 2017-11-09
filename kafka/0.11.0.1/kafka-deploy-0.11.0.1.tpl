<@requirement.HA />
<@requirement.CONS 'kafka' 'true' />
<@requirement.SECRET 'kafka_manager_password' />
<@requirement.PARAM 'stackId' />

<@requirement.CONFORMS>
  <@bash.PROFILE>  
    <@swarm.NETWORK 'kafka-net-${stackId}' />
  
    <#assign zoo_servers = [] />
    <#assign zoo_connect = [] />
  
    <@cloud.DATACENTER ; dc, index, isLast>
      <#assign zoo_servers += ['server.${index}=zookeeper-${dc}-${stackId}:2888:3888'] />
      <#assign zoo_connect += ['zookeeper-${dc}-${stackId}:2181'] />
    </@cloud.DATACENTER>

    <@swarm.SERVICE 'swarmstorage-kafka-${stackId}' 'imagenarium/swarmstorage:0.1'>
      <@service.NETWORK 'kafka-net-${stackId}' />
      <@node.MANAGER />
      <@service.DOCKER_SOCKET />
    </@swarm.SERVICE>
  
    <@cloud.DATACENTER ; dc, index, isLast>
      <@swarm.SERVICE 'zookeeper-${dc}-${stackId}' 'imagenarium/zookeeper:3.4.10'>
        <@service.NETWORK 'kafka-net-${stackId}' />
        <@service.DOCKER_SOCKET />
        <@service.DNSRR />
        <@service.DC dc />
        <@service.CONS 'node.labels.kafka' 'true' />
        <@service.VOLUME 'zookeeper-data-volume-${stackId}' '/data' />
        <@service.VOLUME 'zookeeper-datalog-volume-${stackId}' '/datalog' />
        <@service.ENV 'SERVICE_NAME' 'zookeeper-${dc}-${stackId}' />
        <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-kafka-${stackId}' />
        <@service.ENV 'ZOO_MY_ID' index />
        <@service.ENV 'JMXPORT' '9099' />
        <@service.ENV 'ZOO_SERVERS' zoo_servers?join(" ") />
      </@swarm.SERVICE>
    </@cloud.DATACENTER>
  
    <@docker.CONTAINER 'zookeeper-checker-${stackId}' 'imagenarium/zookeeper-checker:1.0'>
      <@container.NETWORK 'kafka-net-${stackId}' />
      <@container.EPHEMERAL />
      <@container.ENV 'ZOO_CONNECT' zoo_connect?join(",") />
    </@docker.CONTAINER>
  
    <@cloud.DATACENTER ; dc, index, isLast>
      <@swarm.SERVICE 'kafka-${dc}-${stackId}' 'imagenarium/kafka:0.11.0.1'>
        <@service.NETWORK 'kafka-net-${stackId}' />
        <@service.DOCKER_SOCKET />
        <@service.HOSTNAME 'kafka-${dc}-${stackId}' />
        <@service.DNSRR />
        <@service.DC dc />
        <@service.CONS 'node.labels.kafka' 'true' />
        <@service.VOLUME 'kafka-volume-${stackId}' '/kafka' />
        <@service.ENV 'SERVICE_NAME' 'kafka-${dc}-${stackId}' />
        <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-kafka-${stackId}' />
        <@service.ENV 'KAFKA_LISTENERS' 'PLAINTEXT://0.0.0.0:9092' />
        <@service.ENV 'KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS' '10' />
        <@service.ENV 'KAFKA_BROKER_ID' index />
        <@service.ENV 'KAFKA_ZOOKEEPER_CONNECT' zoo_connect?join(",") />
        <@service.ENV 'KAFKA_MESSAGE_MAX_BYTES' '10485760' />
        <@service.ENV 'KAFKA_REPLICA_FETCH_MAX_BYTES' '10485760' />
        <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka-${dc}-${stackId} -Dcom.sun.management.jmxremote.rmi.port=9999 -Djava.net.preferIPv4Stack=true' />
        <@service.ENV 'JMX_PORT' '9999' />
      </@swarm.SERVICE>
    </@cloud.DATACENTER>

    <@swarm.SERVICE 'kafka-manager-${stackId}' 'imagenarium/kafka-manager:1.3.3.13'>
      <@service.NETWORK 'kafka-net-${stackId}' />
      <@service.ENV 'ZK_HOSTS' zoo_connect?join(",") />
    </@swarm.SERVICE>

    <@swarm.SERVICE 'nginx-kafka-manager-${stackId}' 'imagenarium/nginx-basic-auth:1.13.5.1'>
      <@service.SECRET 'kafka_manager_password' />
      <@service.NETWORK 'kafka-net-${stackId}' />
      <@service.PORT '9000' '8080' />
      <@service.ENV 'WEB_USER' 'admin' />
      <@service.ENV 'WEB_PASSWORD_FILE' '/run/secrets/kafka_manager_password' />
      <@service.ENV 'APP_URL' 'http://kafka-manager-${stackId}:9000' />
    </@swarm.SERVICE>
  </@bash.PROFILE>
</@requirement.CONFORMS>