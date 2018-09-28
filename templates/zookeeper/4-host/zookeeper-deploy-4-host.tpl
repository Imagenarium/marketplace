<@requirement.CONS 'zookeeper' '1' />
<@requirement.CONS 'zookeeper' '2' />
<@requirement.CONS 'zookeeper' '3' />

<@requirement.PARAM name='ZOOKEEPER_HEAP_OPTS' value='-Xmx512M -Xms512M' />
<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />
<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <#assign ZOOKEEPER_VERSION='4.1.2' />

  <#assign zoo_servers = [] />
  <#assign zoo_connect = [] />
  
  <#list 1..3 as index>
    <#assign zoo_servers += ['zookeeper-${index}-${namespace}-1:2888:3888'] />
    <#assign zoo_connect += ['zookeeper-${index}-${namespace}-1:2181'] />
  </#list>
  
  <#list 1..3 as index>
    <@swarm.TASK 'zookeeper-${index}-${namespace}'>
      <@container.HOST_NETWORK />
      <@container.VOLUME 'zookeeper-volume-${index}-${namespace}' '/var/lib/zookeeper/data' />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage' />
      <@container.ENV 'ZOOKEEPER_SERVER_ID' '${index}' />
      <#-- <@container.ENV 'ZOOKEEPER_CLIENT_PORT_ADDRESS' '' /> -->
      <@container.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=zookeeper-${index}-${namespace}-1 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.port=9999 -Djava.net.preferIPv4Stack=true' />
      <@container.ENV 'KAFKA_HEAP_OPTS' PARAMS.ZOOKEEPER_HEAP_OPTS />
      <@container.ENV 'ZOOKEEPER_SERVERS' zoo_servers?join(";") />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'zookeeper-${index}-${namespace}' 'imagenarium/cp-zookeeper:${ZOOKEEPER_VERSION}'>
      <@service.CONS 'node.labels.zookeeper' '${index}' />
      <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
      <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
    </@swarm.TASK_RUNNER>
  </#list>

  <@docker.CONTAINER 'zookeeper-checker-${namespace}' 'imagenarium/cp-zookeeper:${ZOOKEEPER_VERSION}'>
    <@container.HOST_NETWORK />
    <@container.ENTRY '/checker.sh' />
    <@container.EPHEMERAL />
    <@container.ENV 'ZOOKEEPER_CONNECT' zoo_connect?join(",") />
    <@container.ENV 'EXPECTED_FOLLOWERS' '${zoo_connect?size - 1}' />
  </@docker.CONTAINER>
</@requirement.CONFORMS>