<@requirement.CONS 'hdfs-data' '1' />
<@requirement.CONS 'hdfs-data' '2' />
<@requirement.CONS 'hdfs-data' '3' />
<@requirement.CONS 'hdfs-name' 'true' />

<@requirement.PARAM name='HADOOP_NAMENODE_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HADOOP_DATANODE_OPTS' value='-Xms1G -Xmx1G' />

<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' scope='global' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />

<@requirement.PARAM name='NAME_WEB_PORT' type='port' required='false' description='Web admin name node port' />
<@requirement.PARAM name='DATA_WEB_PORT' type='port' required='false' description='Web admin data node port' />

<@requirement.CONFORMS>
  <#assign HDFS_VERSION='2.7.6' />
  <@swarm.NETWORK name='hdfs-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-hdfs-${namespace}' 'hdfs-net-${namespace}' />

  <@swarm.TASK 'hdfs-name-${namespace}'>
    <@container.NETWORK 'hdfs-net-${namespace}' />
    <@container.VOLUME 'hdfs-name-volume-${namespace}' '/hadoop/dfs/name' />
    <@container.VOLUME 'hdfs-name-config-volume-${namespace}' '/etc/hadoop' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'NETWORK_NAME' 'hdfs-net-${namespace}' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-hdfs-${namespace}' />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'HADOOP_NAMENODE_OPTS' PARAMS.HADOOP_NAMENODE_OPTS />
    <@container.ENV 'CORE_CONF_fs_defaultFS' 'hdfs://hdfs-name-${namespace}:8020' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'hdfs-name-${namespace}' 'imagenarium/hdfs-namenode:${HDFS_VERSION}'>
    <@service.CONS 'node.labels.hdfs-name' 'true' />
    <@service.PORT PARAMS.NAME_WEB_PORT '50070' />
    <@service.ENV 'PROXY_PORTS' '50070,8020' />
    <@service.NETWORK 'hdfs-net-${namespace}' />
  </@swarm.TASK_RUNNER>

  <@docker.HTTP_CHECKER 'hdfs-checker-${namespace}' 'http://hdfs-name-${namespace}:50070' 'hdfs-net-${namespace}' />

  <#list "1,2,3"?split(",") as index>
    <@swarm.TASK 'hdfs-data-${index}-${namespace}'>
      <@container.NETWORK 'hdfs-net-${namespace}' />
      <@container.VOLUME 'hdfs-data-${index}-volume-${namespace}' '/hadoop/dfs/data' />
      <@container.VOLUME 'hdfs-data-${index}-config-volume-${namespace}' '/etc/hadoop' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'nproc=4096:4096' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.ENV 'NETWORK_NAME' 'hdfs-net-${namespace}' />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-hdfs-${namespace}' />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'HADOOP_DATANODE_OPTS' PARAMS.HADOOP_DATANODE_OPTS />
      <@container.ENV 'CORE_CONF_fs_defaultFS' 'hdfs://hdfs-name-${namespace}:8020' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'hdfs-data-${index}-${namespace}' 'imagenarium/hdfs-datanode:${HDFS_VERSION}'>
      <@service.CONS 'node.labels.hdfs-data' index />
      <@service.PORT PARAMS.DATA_WEB_PORT '50075' 'host' />
      <@service.ENV 'PROXY_PORTS' '50075' />
      <@service.NETWORK 'hdfs-net-${namespace}' />
    </@swarm.TASK_RUNNER>

    <@docker.HTTP_CHECKER 'hdfs-checker-${namespace}' 'http://hdfs-data-${index}-${namespace}:50075' 'hdfs-net-${namespace}' />
  </#list>
</@requirement.CONFORMS>
