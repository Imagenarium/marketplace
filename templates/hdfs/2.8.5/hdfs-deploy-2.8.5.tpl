<@requirement.CONSTRAINT 'hdfs-name' '1' />
<@requirement.CONSTRAINT 'hdfs-name' '2' />

<@requirement.CONSTRAINT 'hdfs-journal' '1' />
<@requirement.CONSTRAINT 'hdfs-journal' '2' />
<@requirement.CONSTRAINT 'hdfs-journal' '3' />

<@requirement.CONSTRAINT 'hdfs-data' '1' />
<@requirement.CONSTRAINT 'hdfs-data' '2' />
<@requirement.CONSTRAINT 'hdfs-data' '3' />

<@requirement.PARAM name='HADOOP_NAMENODE_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HADOOP_DATANODE_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HDFS_NAME_WEB_PORT' type='port' required='false' />
<@requirement.PARAM name='HDFS_DATA_WEB_PORT' type='port' required='false' />

<#assign HDFS_VERSION='2.8.5_1' />

<#list 1..3 as index>
  <@swarm.TASK 'hdfs-journal-${index}-${namespace}'>
    <@container.VOLUME '/hadoop/dfs/data' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'JOURNAL_NODE' 'true' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hdfs-journal-${index}-${namespace}' 'imagenarium/hdfs:${HDFS_VERSION}'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.CONSTRAINT 'hdfs-journal' '${index}' />
    <@service.CHECK_PORT '8485' />
  </@swarm.TASK_RUNNER>
</#list>

<#list 1..2 as index>
  <@swarm.TASK 'hdfs-name-${index}-${namespace}'>
    <@container.VOLUME '/hadoop/dfs/name' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'NAME_NODE' 'true' />
    <@container.ENV 'HADOOP_NAMENODE_OPTS' PARAMS.HADOOP_NAMENODE_OPTS />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hdfs-name-${index}-${namespace}' 'imagenarium/hdfs:${HDFS_VERSION}'>
    <@service.DNSRR />
    <@service.NETWORK 'net-${namespace}' />
    <@service.CONSTRAINT 'hdfs-name' '${index}' />
    <@service.PORT PARAMS.HDFS_NAME_WEB_PORT '50070' 'host' />
    <@service.CHECK_PATH ':50070' />
  </@swarm.TASK_RUNNER>
</#list>

<#list 1..3 as index>
  <@swarm.TASK 'hdfs-data-${index}-${namespace}'>
    <@container.BIND '/var/run' '/var/run/hadoop' />
    <@container.IPC 'shareable' />
    <@container.VOLUME '/hadoop/dfs/data' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'DATA_NODE' 'true' />
    <@container.ENV 'HADOOP_DATANODE_OPTS' PARAMS.HADOOP_DATANODE_OPTS />
    <@container.ENV 'HDFS_CONF_dfs_datanode_max_transfer_threads' '4096' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hdfs-data-${index}-${namespace}' 'imagenarium/hdfs:${HDFS_VERSION}'>
    <@service.DNSRR />
    <@service.NETWORK 'net-${namespace}' />
    <@service.CONSTRAINT 'hdfs-data' '${index}' />
    <@service.PORT PARAMS.HDFS_DATA_WEB_PORT '50075' 'host' />
    <@service.CHECK_PATH ':50075' />
  </@swarm.TASK_RUNNER>
</#list>
