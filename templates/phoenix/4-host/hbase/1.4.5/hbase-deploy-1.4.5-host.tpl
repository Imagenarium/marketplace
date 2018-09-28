<@requirement.CONS 'hdfs-data' '1' />
<@requirement.CONS 'hdfs-data' '2' />
<@requirement.CONS 'hdfs-data' '3' />
<@requirement.CONS 'hdfs-name' 'true' />

<@requirement.PARAM name='HBASE_MASTER_OPTS'       value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HBASE_REGIONSERVER_OPTS' value='-Xms1G -Xmx1G' />

<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />

<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <#assign HBASE_VERSION='1.4.5_1' />

  <#assign zoo_hosts   = [] />
  
  <#list 1..3 as index>
    <#assign zoo_hosts += ['zookeeper-${index}-${namespace}-1'] />
  </#list>
  
  <@swarm.TASK 'hbase-master-${namespace}'>
    <@container.HOST_NETWORK />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'MASTER_EXTERNAL_PORT' PARAMS.MASTER_EXTERNAL_PORT! />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'HBASE_MASTER_OPTS' PARAMS.HBASE_MASTER_OPTS />
    <@container.ENV 'HDFS_HOST' 'hdfs-name-${namespace}-1' />
    <@container.ENV 'HBASE_CONF_hbase_zookeeper_quorum' zoo_hosts?join(",") />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hbase-master-${namespace}' 'imagenarium/hbase-master:${HBASE_VERSION}'>
    <@service.CONS 'node.labels.hdfs-name' 'true' />
    <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
    <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
  </@swarm.TASK_RUNNER>

  <#if PARAMS.ADMIN_MODE == 'false'>
    <@docker.HTTP_CHECKER 'hbase-checker-${namespace}' 'http://hbase-master-${namespace}-1:16010' />
  </#if>

  <#list 1..3 as index>
    <@swarm.TASK 'hbase-regionserver-${index}-${namespace}'>
      <@container.HOST_NETWORK />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'nproc=4096:4096' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.ENV 'REGIONSERVER_EXTERNAL_PORT' PARAMS.REGIONSERVER_EXTERNAL_PORT! />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'HBASE_REGIONSERVER_OPTS' PARAMS.HBASE_REGIONSERVER_OPTS />
      <@container.ENV 'HDFS_HOST' 'hdfs-name-${namespace}-1' />
      <@container.ENV 'HBASE_CONF_hbase_zookeeper_quorum' zoo_hosts?join(",") />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'hbase-regionserver-${index}-${namespace}' 'imagenarium/hbase-regionserver:${HBASE_VERSION}'>
      <@service.CONS 'node.labels.hdfs-data' '${index}' />
      <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
      <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
    </@swarm.TASK_RUNNER>

    <#if PARAMS.ADMIN_MODE == 'false'>
      <@docker.HTTP_CHECKER 'hbase-checker-${namespace}' 'http://hbase-regionserver-${index}-${namespace}-1:16030' />
    </#if>
  </#list>
</@requirement.CONFORMS>