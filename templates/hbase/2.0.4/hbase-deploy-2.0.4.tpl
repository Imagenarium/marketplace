<@requirement.CONSTRAINT 'hbase-master' '1' />
<@requirement.CONSTRAINT 'hbase-master' '2' />
<@requirement.CONSTRAINT 'hbase-master' '3' />

<@requirement.CONSTRAINT 'hdfs-data' '1' />
<@requirement.CONSTRAINT 'hdfs-data' '2' />
<@requirement.CONSTRAINT 'hdfs-data' '3' />

<@requirement.PARAM name='HBASE_MASTER_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='HBASE_REGIONSERVER_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='MASTER_EXTERNAL_PORT' type='port' required='false' />
<@requirement.PARAM name='REGIONSERVER_EXTERNAL_PORT' type='port' required='false' />
<@requirement.PARAM name='MASTER_WEB_PORT' type='port' required='false' />
<@requirement.PARAM name='REGIONSERVER_WEB_PORT' type='port' required='false' />

<#assign HBASE_VERSION='2.0.0_1' />

<#list 1..3 as index>
  <@img.TASK 'hbase-master-${index}-${namespace}' 'imagenarium/hbase:${HBASE_VERSION}'>
    <@img.ULIMIT 'nofile=65536:65536' />
    <@img.ULIMIT 'nproc=4096:4096' />
    <@img.ULIMIT 'memlock=-1:-1' />
    <@img.ENV 'MASTER_NODE' 'true' />
    <@img.ENV 'MASTER_EXTERNAL_PORT' PARAMS.MASTER_EXTERNAL_PORT />
    <@img.ENV 'HBASE_MASTER_OPTS' PARAMS.HBASE_MASTER_OPTS />
    <@img.DNSRR />
    <@img.NETWORK 'net-${namespace}' />
    <@img.CONSTRAINT 'hbase-master' '${index}' />
    <@img.PORT PARAMS.MASTER_WEB_PORT '16010' 'host' />
    <@img.PORT PARAMS.MASTER_EXTERNAL_PORT PARAMS.MASTER_EXTERNAL_PORT 'host' />
    <@img.CHECK_PATH ':16010' />
  </@img.TASK>
</#list>

<#list 1..3 as index>
  <@img.TASK 'hbase-region-${index}-${namespace}' 'imagenarium/hbase:${HBASE_VERSION}'>
    <@img.BIND '/var/run' '/var/run/hadoop' />
    <@img.IPC 'container:hdfs-data-${index}-${namespace}-1' />
    <@img.ULIMIT 'nofile=65536:65536' />
    <@img.ULIMIT 'nproc=4096:4096' />
    <@img.ULIMIT 'memlock=-1:-1' />
    <@img.ENV 'REGION_NODE' 'true' />
    <@img.ENV 'HBASE_REGIONSERVER_OPTS' PARAMS.HBASE_REGIONSERVER_OPTS />
    <@img.ENV 'REGIONSERVER_EXTERNAL_PORT' PARAMS.REGIONSERVER_EXTERNAL_PORT />
    <@img.DNSRR />
    <@img.NETWORK 'net-${namespace}' />
    <@img.CONSTRAINT 'hdfs-data' '${index}' />
    <@img.PORT PARAMS.REGIONSERVER_WEB_PORT '16030' 'host' />
    <@img.PORT PARAMS.REGIONSERVER_EXTERNAL_PORT PARAMS.REGIONSERVER_EXTERNAL_PORT 'host' />
    <@img.CHECK_PATH ':16030' />
  </@img.TASK>
</#list>
