<@requirement.CONS 'phoenix-single' 'true' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />

<@requirement.PARAM name='HBASE_MASTER_OPTS'       value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HBASE_REGIONSERVER_OPTS' value='-Xms1G -Xmx1G' />

<@requirement.PARAM name='PHOENIX_EXTERNAL_PORT'  type='port' required='false' />
<@requirement.PARAM name='MASTER_WEB_PORT'        type='port' required='false' />
<@requirement.PARAM name='REGIONSERVER_WEB_PORT'  type='port' required='false' />

<@requirement.CONFORMS>
  <#assign PHOENIX_VERSION='4.14' />

  <@swarm.NETWORK name='net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.TASK 'phoenix-${namespace}'>
    <@container.NETWORK 'net-${namespace}' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'HBASE_MASTER_OPTS' PARAMS.HBASE_MASTER_OPTS />
    <@container.ENV 'HBASE_REGIONSERVER_OPTS' PARAMS.HBASE_REGIONSERVER_OPTS />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'phoenix-${namespace}' 'imagenarium/phoenix-single:${PHOENIX_VERSION}'>
    <@service.CONS 'node.labels.phoenix-single' 'true' />
    <@service.PORT PARAMS.MASTER_WEB_PORT '16010' />
    <@service.PORT PARAMS.REGIONSERVER_WEB_PORT '16030' />
    <@service.PORT PARAMS.PHOENIX_EXTERNAL_PORT '8765' />
    <@service.ENV 'PROXY_PORTS' '16010,16030,8765' />
  </@swarm.TASK_RUNNER>

  <@docker.TCP_CHECKER 'phoenix-checker-${namespace}' 'phoenix-${namespace}-1:8765' 'net-${namespace}' />
</@requirement.CONFORMS>