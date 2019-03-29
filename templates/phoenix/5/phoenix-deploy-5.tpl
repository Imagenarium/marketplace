<@requirement.CONSTRAINT 'phoenix' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />

<#assign PHOENIX_VERSION='5.0.0' />

<#assign zoo_hosts = [] />
  
<#list 1..3 as index>
  <#assign zoo_hosts += ['zookeeper-${index}-${namespace}'] />
</#list>

<@swarm.SERVICE 'phoenix-${namespace}' 'imagenarium/phoenix:${PHOENIX_VERSION}'>
  <@service.NETWORK 'net-${namespace}' />  
  <@service.DNSRR />
  <@service.PORT PARAMS.PUBLISHED_PORT '8765' 'host' />
  <@service.CONSTRAINT 'phoenix' 'true' />
  <@service.ENV 'HBASE_CONF_hbase_zookeeper_quorum' zoo_hosts?join(",") />
  <@service.CHECK_PORT '8765' />
</@swarm.SERVICE>