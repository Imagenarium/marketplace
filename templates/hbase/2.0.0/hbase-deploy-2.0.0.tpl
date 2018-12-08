<@requirement.CONSTRAINT 'hbase-master' '1' />
<@requirement.CONSTRAINT 'hbase-master' '2' />
<@requirement.CONSTRAINT 'hbase-master' '3' />
<@requirement.CONSTRAINT 'hbase-region' '1' />
<@requirement.CONSTRAINT 'hbase-region' '2' />
<@requirement.CONSTRAINT 'hbase-region' '3' />

<@requirement.PARAM name='HBASE_MASTER_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HBASE_REGIONSERVER_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='MASTER_EXTERNAL_PORT' type='port' required='false' />
<@requirement.PARAM name='REGIONSERVER_EXTERNAL_PORT' type='port' required='false' />
<@requirement.PARAM name='MASTER_WEB_PORT' type='port' required='false' />
<@requirement.PARAM name='REGIONSERVER_WEB_PORT' type='port' required='false' />

<#assign HBASE_VERSION='2.0.0' />

<#assign zoo_hosts = [] />
  
<#list 1..3 as index>
  <#assign zoo_hosts += ['zookeeper-${index}-${namespace}'] />
</#list>

<#list 1..3 as index>
  <@swarm.TASK 'hbase-master-${index}-${namespace}'>
    <@container.NETWORK 'net-${namespace}' />
    <@container.PORT PARAMS.MASTER_WEB_PORT '16010' />
    <@container.PORT PARAMS.MASTER_EXTERNAL_PORT PARAMS.MASTER_EXTERNAL_PORT />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'MASTER_NODE' 'true' />
    <@container.ENV 'MASTER_EXTERNAL_PORT' PARAMS.MASTER_EXTERNAL_PORT />
    <@container.ENV 'HBASE_MASTER_OPTS' PARAMS.HBASE_MASTER_OPTS />
    <@container.ENV 'HDFS_HOST' 'hdfs-name-${namespace}-1' />
    <@container.ENV 'HBASE_CONF_hbase_zookeeper_quorum' zoo_hosts?join(",") />
    <@container.CHECK_PATH ':16010' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hbase-master-${index}-${namespace}' 'imagenarium/hbase:${HBASE_VERSION}'>
    <@service.CONSTRAINT 'hbase-master' '${index}' />
  </@swarm.TASK_RUNNER>
</#list>

<#list 1..3 as index>
  <@swarm.TASK 'hbase-region-${index}-${namespace}'>
    <@container.NETWORK 'net-${namespace}' />
    <@container.PORT PARAMS.REGIONSERVER_WEB_PORT '16030' />
    <@container.PORT PARAMS.REGIONSERVER_EXTERNAL_PORT PARAMS.REGIONSERVER_EXTERNAL_PORT />
    <@container.BIND '/var/run' '/var/run/hadoop' />
    <@container.IPC 'container:hdfs-${index}-${namespace}-1' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'REGION_NODE' 'true' />
    <@container.ENV 'HBASE_REGIONSERVER_OPTS' PARAMS.HBASE_REGIONSERVER_OPTS />
    <@container.ENV 'REGIONSERVER_EXTERNAL_PORT' PARAMS.REGIONSERVER_EXTERNAL_PORT />
    <@container.ENV 'HDFS_HOST' 'hdfs-name-${namespace}-1' />
    <@container.ENV 'HBASE_CONF_hbase_zookeeper_quorum' zoo_hosts?join(",") />
    <@container.CHECK_PATH ':16030' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hbase-region-${index}-${namespace}' 'imagenarium/hbase:${HBASE_VERSION}'>
    <@service.CONSTRAINT 'hbase-region' '${index}' />
  </@swarm.TASK_RUNNER>
</#list>
