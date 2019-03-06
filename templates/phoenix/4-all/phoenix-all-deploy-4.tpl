<@requirement.CONSTRAINT 'phoenix-all' 'true' />

<@requirement.PARAM name='HBASE_MASTER_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='PHOENIX_EXTERNAL_PORT' type='port' required='false' />

<@swarm.SERVICE 'phoenix-${namespace}' 'imagenarium/phoenix-all-in-one:4'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.ENV 'HBASE_MASTER_OPTS' PARAMS.HBASE_MASTER_OPTS />
  <@service.CONSTRAINT 'phoenix-all' 'true' />
  <@service.PORT PARAMS.PHOENIX_EXTERNAL_PORT '8765' />
  <@service.CHECK_PORT '8765' />
</@swarm.SERVICE>