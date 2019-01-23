<@requirement.CONSTRAINT 'zookeeper' '1' />
<@requirement.CONSTRAINT 'zookeeper' '2' />
<@requirement.CONSTRAINT 'zookeeper' '3' />

<@requirement.PARAM name='ZOOKEEPER_HEAP_OPTS' value='-Xmx512M -Xms512M' />
<@requirement.PARAM name='ZOOKEEPER_PORT' type='port' required='false' />

<#assign ZOOKEEPER_VERSION='5.1' />

<#assign zoo_servers = [] />
<#assign zoo_connect = [] />
  
<#list 1..3 as index>
  <#assign zoo_servers += ['zookeeper-${index}-${namespace}:2888:3888'] />
  <#assign zoo_connect += ['zookeeper-${index}-${namespace}:2181'] />
</#list>
  
<#list 1..3 as index>
  <@swarm.SERVICE 'zookeeper-${index}-${namespace}' 'imagenarium/cp-zookeeper:${ZOOKEEPER_VERSION}'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.PORT PARAMS.ZOOKEEPER_PORT '2181' 'host' />
    <@service.DNSRR />
    <@service.CONSTRAINT 'zookeeper' '${index}' />
    <@service.VOLUME '/var/lib/zookeeper/data' />
    <@service.ENV 'ZOOKEEPER_SERVER_ID' '${index}' />
    <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=zookeeper-${index}-${namespace} -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.port=9999 -Djava.net.preferIPv4Stack=true' />
    <@service.ENV 'KAFKA_HEAP_OPTS' PARAMS.ZOOKEEPER_HEAP_OPTS />
    <@service.ENV 'ZOOKEEPER_SERVERS' zoo_servers?join(";") />
  </@swarm.SERVICE>
</#list>

<@docker.CONTAINER 'zookeeper-checker-${namespace}' 'imagenarium/cp-zookeeper:${ZOOKEEPER_VERSION}'>
  <@container.ENTRY '/checker.sh' />
  <@container.NETWORK 'net-${namespace}' />
  <@container.EPHEMERAL />
  <@container.ENV 'ZOOKEEPER_CONNECT' zoo_connect?join(",") />
  <@container.ENV 'EXPECTED_FOLLOWERS' '${zoo_connect?size - 1}' />
</@docker.CONTAINER>
