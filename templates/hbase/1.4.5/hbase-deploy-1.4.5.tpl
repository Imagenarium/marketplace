<@requirement.CONS 'hdfs-data' '1' />
<@requirement.CONS 'hdfs-data' '2' />
<@requirement.CONS 'hdfs-data' '3' />
<@requirement.CONS 'hdfs-name' 'true' />

<@requirement.PARAM name='HADOOP_NAMENODE_OPTS'    value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HADOOP_DATANODE_OPTS'    value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HBASE_MASTER_OPTS'       value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HBASE_REGIONSERVER_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='ZOOKEEPER_HEAP_OPTS'     value='-Xmx512M -Xms512M' />

<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' scope='global' />

<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />

<@requirement.PARAM name='REGIONSERVER_EXTERNAL_PORT' type='port' required='false' />
<@requirement.PARAM name='MASTER_EXTERNAL_PORT'       type='port' required='false' />

<@requirement.PARAM name='ZOOKEEPER_PORT'         type='port' required='false' />
<@requirement.PARAM name='NAME_WEB_PORT'          type='port' required='false' />
<@requirement.PARAM name='DATA_WEB_PORT'          type='port' required='false' />
<@requirement.PARAM name='MASTER_WEB_PORT'        type='port' required='false' />
<@requirement.PARAM name='REGIONSERVER_WEB_PORT'  type='port' required='false' />

<@requirement.CONFORMS>
  <#assign HDFS_VERSION='2.7.6' />
  <#assign HBASE_VERSION='1.4.5' />

  <@swarm.NETWORK name='hadoop-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-hadoop-${namespace}' 'hadoop-net-${namespace}' />

  <@swarm.TASK 'hdfs-name-${namespace}'>
    <@container.NETWORK 'hadoop-net-${namespace}' />
    <@container.VOLUME 'hdfs-name-volume-${namespace}' '/hadoop/dfs/name' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'NETWORK_NAME' 'hadoop-net-${namespace}' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-hadoop-${namespace}' />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'HADOOP_NAMENODE_OPTS' PARAMS.HADOOP_NAMENODE_OPTS />
    <@container.ENV 'CORE_CONF_fs_defaultFS' 'hdfs://hdfs-name-${namespace}-1:8020' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hdfs-name-${namespace}' 'imagenarium/hdfs-namenode:${HDFS_VERSION}'>
    <@service.CONS 'node.labels.hdfs-name' 'true' />
    <@service.PORT PARAMS.NAME_WEB_PORT '50070' />
    <@service.ENV 'PROXY_PORTS' '50070' />
    <@service.NETWORK 'hadoop-net-${namespace}' />
  </@swarm.TASK_RUNNER>

  <@docker.HTTP_CHECKER 'hdfs-checker-${namespace}' 'http://hdfs-name-${namespace}:50070' 'hadoop-net-${namespace}' />

  <#list 1..3 as index>
    <@swarm.TASK 'hdfs-data-${index}-${namespace}'>
      <@container.NETWORK 'hadoop-net-${namespace}' />
      <@container.VOLUME 'hdfs-data-${index}-volume-${namespace}' '/hadoop/dfs/data' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'nproc=4096:4096' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.ENV 'NETWORK_NAME' 'hadoop-net-${namespace}' />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-hadoop-${namespace}' />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'HADOOP_DATANODE_OPTS' PARAMS.HADOOP_DATANODE_OPTS />
      <@container.ENV 'CORE_CONF_fs_defaultFS' 'hdfs://hdfs-name-${namespace}-1:8020' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'hdfs-data-${index}-${namespace}' 'imagenarium/hdfs-datanode:${HDFS_VERSION}'>
      <@service.CONS 'node.labels.hdfs-data' '${index}' />
      <@service.PORT PARAMS.DATA_WEB_PORT '50075' 'host' />
      <@service.ENV 'PROXY_PORTS' '50075' />
      <@service.NETWORK 'hadoop-net-${namespace}' />
    </@swarm.TASK_RUNNER>

    <@docker.HTTP_CHECKER 'hdfs-checker-${namespace}' 'http://hdfs-data-${index}-${namespace}:50075' 'hadoop-net-${namespace}' />
  </#list>

  <#assign zoo_servers = [] />
  <#assign zoo_connect = [] />
  <#assign zoo_hosts   = [] />
  
  <#list 1..3 as index>
    <#assign zoo_servers += ['zookeeper-${index}-${namespace}:2888:3888'] />
    <#assign zoo_connect += ['zookeeper-${index}-${namespace}:2181'] />
    <#assign zoo_hosts   += ['zookeeper-${index}-${namespace}'] />
  </#list>
  
  <#list 1..3 as index>
    <@swarm.SERVICE 'zookeeper-${index}-${namespace}' 'imagenarium/cp-zookeeper:4.1.1'>
      <@service.NETWORK 'hadoop-net-${namespace}' />
      <@service.PORT PARAMS.ZOOKEEPER_PORT '2181' 'host' />
      <@service.DNSRR />
      <@service.CONS 'node.labels.hdfs-data' '${index}' />
      <@service.VOLUME 'zookeeper-volume-${index}-${namespace}' '/var/lib/zookeeper/data' />
      <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-hadoop-${namespace}' />
      <@service.ENV 'ZOOKEEPER_SERVER_ID' '${index}' />
      <@service.ENV 'KAFKA_JMX_OPTS' '-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=zookeeper-${index}-${namespace} -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.port=9999 -Djava.net.preferIPv4Stack=true' />
      <@service.ENV 'KAFKA_HEAP_OPTS' PARAMS.ZOOKEEPER_HEAP_OPTS />
      <@service.ENV 'ZOOKEEPER_SERVERS' zoo_servers?join(";") />
    </@swarm.SERVICE>
  </#list>

  <@docker.CONTAINER 'zookeeper-checker-${namespace}' 'imagenarium/cp-zookeeper:4.1.1'>
    <@container.ENTRY '/checker.sh' />
    <@container.NETWORK 'hadoop-net-${namespace}' />
    <@container.EPHEMERAL />
    <@container.ENV 'ZOOKEEPER_CONNECT' zoo_connect?join(",") />
    <@container.ENV 'EXPECTED_FOLLOWERS' '${zoo_connect?size - 1}' />
  </@docker.CONTAINER>

  <@swarm.TASK 'hbase-master-${namespace}'>
    <@container.NETWORK 'hadoop-net-${namespace}' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'MASTER_EXTERNAL_PORT' PARAMS.MASTER_EXTERNAL_PORT! />
    <@container.ENV 'NETWORK_NAME' 'hadoop-net-${namespace}' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-hadoop-${namespace}' />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'HBASE_MASTER_OPTS' PARAMS.HBASE_MASTER_OPTS />
    <@container.ENV 'HDFS_HOST' 'hdfs-name-${namespace}-1' />
    <@container.ENV 'ZOOKEEPER_SERVERS' zoo_hosts?join(",") />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hbase-master-${namespace}' 'imagenarium/hbase-master:${HBASE_VERSION}'>
    <@service.CONS 'node.labels.hdfs-name' 'true' />
    <@service.PORT PARAMS.MASTER_WEB_PORT '16010' />
    <@service.PORT PARAMS.MASTER_EXTERNAL_PORT PARAMS.MASTER_EXTERNAL_PORT 'host' />
    <@service.ENV 'PROXY_PORTS' '16010,${PARAMS.MASTER_EXTERNAL_PORT}' />
    <@service.NETWORK 'hadoop-net-${namespace}' />
  </@swarm.TASK_RUNNER>

  <@docker.HTTP_CHECKER 'hbase-checker-${namespace}' 'http://hbase-master-${namespace}:16010' 'hadoop-net-${namespace}' />

  <#list 1..3 as index>
    <@swarm.TASK 'hbase-regionserver-${index}-${namespace}'>
      <@container.NETWORK 'hadoop-net-${namespace}' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'nproc=4096:4096' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.VOLUME 'hbase-regionserver-logvolume-${index}-${namespace}' '/opt/hbase-${HBASE_VERSION}/logs' />
      <@container.ENV 'REGIONSERVER_EXTERNAL_PORT' PARAMS.REGIONSERVER_EXTERNAL_PORT! />
      <@container.ENV 'NETWORK_NAME' 'hadoop-net-${namespace}' />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-hadoop-${namespace}' />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'HBASE_REGIONSERVER_OPTS' PARAMS.HBASE_REGIONSERVER_OPTS />
      <@container.ENV 'HDFS_HOST' 'hdfs-name-${namespace}-1' />
      <@container.ENV 'ZOOKEEPER_SERVERS' zoo_hosts?join(",") />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'hbase-regionserver-${index}-${namespace}' 'imagenarium/hbase-regionserver:${HBASE_VERSION}'>
      <@service.CONS 'node.labels.hdfs-data' '${index}' />
      <@service.PORT PARAMS.REGIONSERVER_WEB_PORT '16030' 'host' />
      <@service.PORT PARAMS.REGIONSERVER_EXTERNAL_PORT PARAMS.REGIONSERVER_EXTERNAL_PORT 'host' />
      <@service.ENV 'PROXY_PORTS' '16030,${PARAMS.REGIONSERVER_EXTERNAL_PORT}' />
      <@service.NETWORK 'hadoop-net-${namespace}' />
    </@swarm.TASK_RUNNER>

    <@docker.HTTP_CHECKER 'hbase-checker-${namespace}' 'http://hbase-regionserver-${index}-${namespace}:16030' 'hadoop-net-${namespace}' />
  </#list>
</@requirement.CONFORMS>
