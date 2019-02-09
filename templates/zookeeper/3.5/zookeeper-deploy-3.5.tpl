<@requirement.CONSTRAINT 'zookeeper' '1' />
<@requirement.CONSTRAINT 'zookeeper' '2' />
<@requirement.CONSTRAINT 'zookeeper' '3' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />

<#assign ZOOKEEPER_VERSION='3.5' />

<#assign zoo_servers = [] />
<#assign zoo_connect = [] />
  
<#list 1..3 as index>
  <#assign zoo_servers += ['server.${index}=zookeeper-${index}-${namespace}:2888:3888;0.0.0.0:2181'] />
  <#assign zoo_connect += ['zookeeper-${index}-${namespace}:2181'] />
</#list>
  
<#list 1..3 as index>
  <@swarm.SERVICE 'zookeeper-${index}-${namespace}' 'imagenarium/zookeeper:${ZOOKEEPER_VERSION}'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '2181' 'host' />
    <@service.DNSRR />
    <@service.CONSTRAINT 'zookeeper' '${index}' />
    <@service.VOLUME '/data' />
    <@service.ENV 'ZOO_MY_ID' '${index}' />
    <@service.ENV 'ZOO_SERVERS' zoo_servers?join(" ") />
  </@swarm.SERVICE>
</#list>

<@docker.CONTAINER 'zookeeper-checker-${namespace}' 'imagenarium/zookeeper:${ZOOKEEPER_VERSION}'>
  <@container.ENTRY '/checker.sh' />
  <@container.NETWORK 'net-${namespace}' />
  <@container.EPHEMERAL />
  <@container.ENV 'ZOOKEEPER_CONNECT' zoo_connect?join(",") />
  <@container.ENV 'EXPECTED_FOLLOWERS' '${zoo_connect?size - 1}' />
</@docker.CONTAINER>
