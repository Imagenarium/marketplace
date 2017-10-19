<@requirement.HA />
<@requirement.CONS 'kafka' 'true' />

<@requirement.CONFORMS>
  <@bash.PROFILE>
    <#assign ZOOKEEPER_VERSION='3.4.10' />
    <#assign KAFKA_VERSION='0.11.0.0' />
  
    <@swarm.NETWORK 'kafka-net' />
  
    <#assign zoo_servers = [] />
    <#assign zoo_connect = [] />
  
    <@node.DATACENTER ; dc, index, isLast>
      <#assign zoo_servers += ['server.${index}=zookeeper-${dc}:2888:3888'] />
      <#assign zoo_connect += ['zookeeper-${dc}:2181'] />
    </@node.DATACENTER>
  
    <@node.DATACENTER ; dc, index, isLast>
      <@swarm.SERVICE 'zookeeper-${dc}' 'zookeeper:${ZOOKEEPER_VERSION}'>
        <@service.NETWORK 'kafka-net' />
        <@service.DNSRR />
        <@service.DC dc />
        <@service.CONS 'node.labels.kafka' 'true' />
        <@service.VOLUME 'zookeeper-data-volume' '/data' />
        <@service.VOLUME 'zookeeper-datalog-volume' '/datalog' />
        <@service.ENV 'ZOO_MY_ID' index />
        <@service.ENV 'JMXPORT' '9099' />
        <@service.ENV 'ZOO_SERVERS' zoo_servers?join(" ") />
      </@swarm.SERVICE>
    </@node.DATACENTER>
  
    <@docker.CONTAINER 'zookeeper-checker' 'imagenarium/zookeeper-checker:1.0'>
      <@container.NETWORK 'kafka-net' />
      <@container.EPHEMERAL />
      <@container.ENV 'ZOO_CONNECT' zoo_connect?join(",") />
    </@docker.CONTAINER>
  
    <@node.DATACENTER ; dc, index, isLast>
      <@swarm.SERVICE 'kafka-${dc}' 'wurstmeister/kafka:${KAFKA_VERSION}'>
        <@service.NETWORK 'kafka-net' />
        <@service.HOSTNAME 'kafka-${dc}' />
        <@service.DNSRR />
        <@service.DC dc />
        <@service.CONS 'node.labels.kafka' 'true' />
        <@service.VOLUME 'kafka-volume' '/kafka' />
        <@service.ENV 'KAFKA_LISTENERS' 'PLAINTEXT://0.0.0.0:9092' />
        <@service.ENV 'KAFKA_LEADER_IMBALANCE_CHECK_INTERVAL_SECONDS' '10' />
        <@service.ENV 'KAFKA_BROKER_ID' index />
        <@service.ENV 'KAFKA_ZOOKEEPER_CONNECT' zoo_connect?join(",") />
        <@service.ENV 'KAFKA_MESSAGE_MAX_BYTES' '10485760' />
        <@service.ENV 'KAFKA_REPLICA_FETCH_MAX_BYTES' '10485760' />
        <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka-${dc} -Dcom.sun.management.jmxremote.rmi.port=9999 -Djava.net.preferIPv4Stack=true' />
        <@service.ENV 'JMX_PORT' '9999' />
      </@swarm.SERVICE>
    </@node.DATACENTER>

    <@swarm.SERVICE 'kafka-manager' 'imagenarium/kafka-manager:1.3.3.13'>
      <@service.NETWORK 'kafka-net' />
      <@service.ENV 'ZK_HOSTS' zoo_connect?join(",") />
    </@swarm.SERVICE>

    <@swarm.SERVICE 'nginx-kafka-manager' 'imagenarium/nginx-basic-auth:1.13.5.1'>
      <@service.NETWORK 'kafka-net' />
      <@service.PORT '9000' '8080' />
      <@service.ENV 'WEB_USER' 'man4j' />
      <@service.ENV 'WEB_PASSWORD' '$apr1$h9Xllpx6$bBVR6h5YDkCRJACM2wfgg/' />
      <@service.ENV 'APP_URL' 'http://kafka-manager:9000' />
    </@swarm.SERVICE>
  </@bash.PROFILE>
</@requirement.CONFORMS>