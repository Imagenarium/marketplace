<@requirement.CONSTRAINT 'hbase-master' 'true' />
<@requirement.CONSTRAINT 'hbase-region' '1' />
<@requirement.CONSTRAINT 'hbase-region' '2' />
<@requirement.CONSTRAINT 'hbase-region' '3' />

<@requirement.PARAM name='HADOOP_NAMENODE_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HADOOP_SECONDARYNAMENODE_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HADOOP_DATANODE_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HDFS_NAME_WEB_PORT' type='port' required='false' />
<@requirement.PARAM name='HDFS_DATA_WEB_PORT' type='port' required='false' />

<#assign HDFS_VERSION='2.8.5' />

<#assign zoo_hosts   = [] />
  
<#list 1..3 as index>
  <#assign zoo_hosts += ['zookeeper-${index}-${namespace}'] />
</#list>

<@swarm.TASK 'hdfs-name-${namespace}'>
  <@container.NETWORK 'net-${namespace}' />
  <@container.PORT PARAMS.HDFS_NAME_WEB_PORT '50070' />
  <@container.VOLUME '/hadoop/dfs/name' />
  <@container.ULIMIT 'nofile=65536:65536' />
  <@container.ULIMIT 'nproc=4096:4096' />
  <@container.ULIMIT 'memlock=-1:-1' />
  <@container.ENV 'NAME_NODE' 'true' />
  <@container.ENV 'HADOOP_NAMENODE_OPTS' PARAMS.HADOOP_NAMENODE_OPTS />
  <@container.ENV 'CORE_CONF_fs_defaultFS' 'hdfs://hdfs-name-${namespace}-1:8020' />
</@swarm.TASK>

<@swarm.TASK_RUNNER 'hdfs-name-${namespace}' 'imagenarium/hdfs:${HDFS_VERSION}'>
  <@service.CONSTRAINT 'hbase-master' 'true' />
</@swarm.TASK_RUNNER>

<@docker.HTTP_CHECKER 'checker-${namespace}' 'http://hdfs-name-${namespace}-1:50070' 'net-${namespace}' />

<#list 1..3 as index>
  <@swarm.TASK 'hdfs-${index}-${namespace}'>
    <@container.NETWORK 'net-${namespace}' />
    <@container.PORT PARAMS.HDFS_DATA_WEB_PORT '50075' />
    <@container.BIND '/var/run' '/var/run/hadoop' />
    <@container.IPC 'shareable' />
    <@container.VOLUME '/hadoop/dfs/data' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'DATA_NODE' 'true' />
    <@container.ENV 'HADOOP_DATANODE_OPTS' PARAMS.HADOOP_DATANODE_OPTS />
    <@container.ENV 'CORE_CONF_fs_defaultFS' 'hdfs://hdfs-name-${namespace}-1:8020' />
    <@container.ENV 'HDFS_CONF_dfs_datanode_max_transfer_threads' '4096' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hdfs-${index}-${namespace}' 'imagenarium/hdfs:${HDFS_VERSION}'>
    <@service.CONSTRAINT 'hbase-region' '${index}' />
  </@swarm.TASK_RUNNER>

  <@docker.HTTP_CHECKER 'checker-${namespace}' 'http://hdfs-${index}-${namespace}-1:50075' 'net-${namespace}' />
</#list>
