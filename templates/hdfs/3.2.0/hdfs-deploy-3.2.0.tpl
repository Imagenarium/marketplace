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

<#assign HDFS_VERSION='3.2.0' />

<#list 1..3 as index>
  <@img.TASK 'hdfs-journal-${index}-${namespace}' 'imagenarium/hdfs:${HDFS_VERSION}'>
    <@img.VOLUME '/hadoop/dfs/data' />
    <@img.ULIMIT 'nofile=65536:65536' />
    <@img.ULIMIT 'nproc=4096:4096' />
    <@img.ULIMIT 'memlock=-1:-1' />
    <@img.ENV 'JOURNAL_NODE' 'true' />
    <@img.NETWORK 'net-${namespace}' />
    <@img.CONSTRAINT 'hdfs-journal' '${index}' />
    <@img.CHECK_PORT '8485' />
  </@img.TASK>
</#list>

<#list 1..2 as index>
  <@img.TASK 'hdfs-name-${index}-${namespace}' 'imagenarium/hdfs:${HDFS_VERSION}'>
    <@img.VOLUME '/hadoop/dfs/name' />
    <@img.ULIMIT 'nofile=65536:65536' />
    <@img.ULIMIT 'nproc=4096:4096' />
    <@img.ULIMIT 'memlock=-1:-1' />
    <@img.ENV 'NAME_NODE' 'true' />
    <@img.ENV 'HADOOP_NAMENODE_OPTS' PARAMS.HADOOP_NAMENODE_OPTS />
    <@img.DNSRR />
    <@img.NETWORK 'net-${namespace}' />
    <@img.CONSTRAINT 'hdfs-name' '${index}' />
    <@img.PORT PARAMS.HDFS_NAME_WEB_PORT '50070' 'host' />
    <@img.CHECK_PATH ':50070' />
  </@img.TASK>
</#list>

<#list 1..3 as index>
  <@img.TASK 'hdfs-data-${index}-${namespace}' 'imagenarium/hdfs:${HDFS_VERSION}'>
    <@img.BIND '/var/run' '/var/run/hadoop' />
    <@img.IPC 'shareable' />
    <@img.VOLUME '/hadoop/dfs/data' />
    <@img.ULIMIT 'nofile=65536:65536' />
    <@img.ULIMIT 'nproc=4096:4096' />
    <@img.ULIMIT 'memlock=-1:-1' />
    <@img.ENV 'DATA_NODE' 'true' />
    <@img.ENV 'HADOOP_DATANODE_OPTS' PARAMS.HADOOP_DATANODE_OPTS />
    <@img.ENV 'HDFS_CONF_dfs_datanode_max_transfer_threads' '4096' />
    <@img.DNSRR />
    <@img.NETWORK 'net-${namespace}' />
    <@img.CONSTRAINT 'hdfs-data' '${index}' />
    <@img.PORT PARAMS.HDFS_DATA_WEB_PORT '50075' 'host' />
    <@img.CHECK_PATH ':50075' />
  </@img.TASK>
</#list>
