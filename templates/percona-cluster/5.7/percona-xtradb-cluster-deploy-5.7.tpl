<@requirement.CONSTRAINT 'percona' '1' />
<@requirement.CONSTRAINT 'percona' '2' />
<@requirement.CONSTRAINT 'percona' '3' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify mysql external port (for example 3306)' />
<@requirement.PARAM name='PMM_PUBLISHED_PORT' value='3380' type='port' required='false' />
<@requirement.PARAM name='PMM_USER' value='admin' />
<@requirement.PARAM name='PMM_PASSWORD' value='admin' type='password' />
<@requirement.PARAM name='DEFAULT_DB_NAME' value='testdb' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' type='password' />
<@requirement.PARAM name='GCACHE_SIZE' value='128M' />
<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />

<#assign PERCONA_VERSION='5.7.23_1' />
  
<#macro checkNode nodeName>
  <@docker.CONTAINER 'percona-node-checker-${namespace}' 'imagenarium/percona-xtradb-cluster:${PERCONA_VERSION}'>
    <@container.NETWORK 'percona-net-${namespace}' />
    <@container.ENV 'MYSQL_HOST' nodeName />
    <@container.ENTRY '/check_remote.sh' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</#macro>

<@swarm.SERVICE 'pmm-${namespace}' 'imagenarium/pmm:latest'>
  <@service.NETWORK 'percona-net-${namespace}' />
  <@service.PORT PARAMS.PMM_PUBLISHED_PORT '80' />
  <@service.CONSTRAINT 'percona' '1' />
  <@service.VOLUME '/opt/prometheus/data' />
  <@service.VOLUME '/opt/consul-data' />
  <@service.VOLUME '/var/lib/mysql' />
  <@service.VOLUME '/var/lib/grafana' />
  <@service.ENV 'SERVER_USER' PARAMS.PMM_USER />
  <@service.ENV 'SERVER_PASSWORD' PARAMS.PMM_PASSWORD />
  <@service.CHECK_PORT '80' />
</@swarm.SERVICE>
  
<#if PARAMS.DELETE_DATA == 'true'>
  <@docker.CONTAINER 'percona-init-${namespace}' 'imagenarium/percona-xtradb-cluster:${PERCONA_VERSION}'>
    <@container.NETWORK 'percona-net-${namespace}' />
    <@container.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    <@container.ENV 'MYSQL_DATABASE' PARAMS.DEFAULT_DB_NAME />
    <@container.ENV 'NETWORK_NAME' 'percona-net-${namespace}' />
    <@container.EPHEMERAL />
    <@container.DAEMON />
  </@docker.CONTAINER>
  
  <@checkNode 'percona-init-${namespace}' />
</#if>

<#list 1..3 as index>
  <#assign nodes = ["percona-init-${namespace}"] />

  <#list 1..3 as _index>
    <#if index != _index>
      <#assign nodes += ["percona-${_index}-${namespace}"] />
    </#if>
  </#list>
    
  <@swarm.SERVICE 'percona-${index}-${namespace}' 'imagenarium/percona-xtradb-cluster:${PERCONA_VERSION}' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
    <@service.NETWORK 'percona-net-${namespace}' />
    <@service.CONSTRAINT 'percona' '${index}' />
    <@service.VOLUME '/var/lib/mysql' />
    <@service.ENV 'NETWORK_NAME' 'percona-net-${namespace}' />
    <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    <@service.ENV 'CLUSTER_JOIN' nodes?join(",") />
    <@service.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
    <@service.ENV 'GCACHE_SIZE' PARAMS.GCACHE_SIZE />
    <@service.ENV 'PMM_USER' PARAMS.PMM_USER />
    <@service.ENV 'PMM_PASSWORD' PARAMS.PMM_PASSWORD />
  </@swarm.SERVICE>
</#list>

<#list 1..3 as index>
  <@checkNode 'percona-${index}-${namespace}' />  
</#list>

<@docker.CONTAINER_RM 'percona-init-${namespace}' />

<@swarm.SERVICE 'proxysql-${namespace}' 'imagenarium/proxysql'>
  <@service.NETWORK 'percona-net-${namespace}' />
  <@service.ENV 'NETWORK_NAME' 'percona-net-${namespace}' />
  <@service.ENV 'MYSQL_HOST' 'percona-1-${namespace}' />
  <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
  <@service.ENV 'PMM_USER' PARAMS.PMM_USER />
  <@service.ENV 'PMM_PASSWORD' PARAMS.PMM_PASSWORD />
  <@service.CHECK_PORT '6032' />
  <@service.CHECK_PORT '6033' />
</@swarm.SERVICE>
