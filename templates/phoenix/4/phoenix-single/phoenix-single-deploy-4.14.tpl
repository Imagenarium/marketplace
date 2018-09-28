<@requirement.CONS 'phoenix-single' 'true' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />
<@requirement.PARAM name='HBASE_MASTER_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='PHOENIX_EXTERNAL_PORT' type='port' required='false' />

<@requirement.CONFORMS>
  <#assign PHOENIX_VERSION='4.14' />

  <@swarm.NETWORK name='net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.SERVICE 'phoenix-${namespace}' 'imagenarium/phoenix-single:${PHOENIX_VERSION}'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.ENV 'HBASE_MASTER_OPTS' PARAMS.HBASE_MASTER_OPTS />
    <@service.CONS 'node.labels.phoenix-single' 'true' />
    <@service.PORT PARAMS.PHOENIX_EXTERNAL_PORT '8765' />
  </@swarm.SERVICE>

  <@docker.TCP_CHECKER 'phoenix-checker-${namespace}' 'phoenix-${namespace}:8765' 'net-${namespace}' />
</@requirement.CONFORMS>