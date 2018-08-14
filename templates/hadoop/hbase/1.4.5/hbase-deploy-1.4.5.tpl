<@requirement.CONS 'hdfs-data' '1' />
<@requirement.CONS 'hdfs-data' '2' />
<@requirement.CONS 'hdfs-data' '3' />
<@requirement.CONS 'hdfs-name' 'true' />

<@requirement.PARAM name='HBASE_MASTER_OPTS'       value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HBASE_REGIONSERVER_OPTS' value='-Xms1G -Xmx1G' />

<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />

<@requirement.PARAM name='REGIONSERVER_EXTERNAL_PORT' type='port' required='false' />
<@requirement.PARAM name='MASTER_EXTERNAL_PORT'       type='port' required='false' />

<@requirement.PARAM name='MASTER_WEB_PORT'        type='port' required='false' />
<@requirement.PARAM name='REGIONSERVER_WEB_PORT'  type='port' required='false' />

<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <#assign HBASE_VERSION='1.4.5' />

  <@swarm.STORAGE 'swarmstorage-hbase-${namespace}' 'hadoop-net-${namespace}' />

  <#assign zoo_hosts   = [] />
  
  <#list 1..3 as index>
    <#assign zoo_hosts += ['zookeeper-${index}-${namespace}'] />
  </#list>
  
  <@swarm.TASK 'hbase-master-${namespace}'>
    <@container.NETWORK 'hadoop-net-${namespace}' />
    <@container.NETWORK 'zookeeper-net-${namespace}' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'MASTER_EXTERNAL_PORT' PARAMS.MASTER_EXTERNAL_PORT! />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-hbase-${namespace}' />
    <@container.ENV 'IMAGENARIUM_DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'HBASE_MASTER_OPTS' PARAMS.HBASE_MASTER_OPTS />
    <@container.ENV 'HDFS_HOST' 'hdfs-name-${namespace}-1' />
    <@container.ENV 'HBASE_CONF_hbase_zookeeper_quorum' zoo_hosts?join(",") />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hbase-master-${namespace}' 'imagenarium/hbase-master-new:${HBASE_VERSION}'>
    <@service.CONS 'node.labels.hdfs-name' 'true' />
    <@service.PORT PARAMS.MASTER_WEB_PORT '16010' />
    <@service.PORT PARAMS.MASTER_EXTERNAL_PORT PARAMS.MASTER_EXTERNAL_PORT 'host' />
    <@service.ENV 'PROXY_PORTS' '16010,${PARAMS.MASTER_EXTERNAL_PORT}' />
    <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
    <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
  </@swarm.TASK_RUNNER>

  <#if PARAMS.ADMIN_MODE == 'false'>
    <@docker.HTTP_CHECKER 'hbase-checker-${namespace}' 'http://hbase-master-${namespace}-1:16010' 'hadoop-net-${namespace}' />
  </#if>

  <#list 1..3 as index>
    <@swarm.TASK 'hbase-regionserver-${index}-${namespace}'>
      <@container.NETWORK 'hadoop-net-${namespace}' />
      <@container.NETWORK 'zookeeper-net-${namespace}' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'nproc=4096:4096' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.VOLUME 'hbase-regionserver-logvolume-${index}-${namespace}' '/opt/hbase-${HBASE_VERSION}/logs' />
      <@container.ENV 'REGIONSERVER_EXTERNAL_PORT' PARAMS.REGIONSERVER_EXTERNAL_PORT! />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-hbase-${namespace}' />
      <@container.ENV 'IMAGENARIUM_DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'HBASE_REGIONSERVER_OPTS' PARAMS.HBASE_REGIONSERVER_OPTS />
      <@container.ENV 'HDFS_HOST' 'hdfs-name-${namespace}-1' />
      <@container.ENV 'HBASE_CONF_hbase_zookeeper_quorum' zoo_hosts?join(",") />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'hbase-regionserver-${index}-${namespace}' 'imagenarium/hbase-regionserver-new:${HBASE_VERSION}'>
      <@service.CONS 'node.labels.hdfs-data' '${index}' />
      <@service.PORT PARAMS.REGIONSERVER_WEB_PORT '16030' 'host' />
      <@service.PORT PARAMS.REGIONSERVER_EXTERNAL_PORT PARAMS.REGIONSERVER_EXTERNAL_PORT 'host' />
      <@service.ENV 'PROXY_PORTS' '16030,${PARAMS.REGIONSERVER_EXTERNAL_PORT}' />
      <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
      <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
    </@swarm.TASK_RUNNER>

    <#if PARAMS.ADMIN_MODE == 'false'>
      <@docker.HTTP_CHECKER 'hbase-checker-${namespace}' 'http://hbase-regionserver-${index}-${namespace}-1:16030' 'hadoop-net-${namespace}' />
    </#if>
  </#list>
</@requirement.CONFORMS>
