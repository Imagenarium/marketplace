<@requirement.CONS 'phoenix' 'true' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />

<@requirement.PARAM name='PHOENIX_EXTERNAL_PORT' type='port' required='false' />

<@requirement.CONFORMS>
  <#assign PHOENIX_VERSION='4.14' />

  <#assign zoo_hosts = [] />
  
  <#list 1..3 as index>
    <#assign zoo_hosts += ['zookeeper-${index}-${namespace}'] />
  </#list>

  <@swarm.SERVICE 'phoenix-${namespace}' 'imagenarium/phoenix:${PHOENIX_VERSION}'>
    <@service.NETWORK 'hadoop-net-${namespace}' />
    <@service.NETWORK 'zookeeper-net-${namespace}' />
    <@service.PORT PARAMS.PHOENIX_EXTERNAL_PORT '8765' />
    <@service.ENV 'HBASE_CONF_hbase_zookeeper_quorum' zoo_hosts?join(",") />
  </@swarm.SERVICE>
  
  <@docker.TCP_CHECKER 'phoenix-checker-${namespace}' 'phoenix-${namespace}:8765' 'hadoop-net-${namespace}' />
</@requirement.CONFORMS>