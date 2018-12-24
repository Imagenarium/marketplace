<@requirement.CONSTRAINT 'percona' '1' />
<@requirement.CONSTRAINT 'percona' '2' />
<@requirement.CONSTRAINT 'percona' '3' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify mysql external port (for example 3306)' />
<@requirement.PARAM name='RUN_ORDER' value='1,2,3' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' type='password' />
<@requirement.PARAM name='GCACHE_SIZE' value='128M' />
<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />

<#assign PERCONA_VERSION='5.7.23' />
  
<#macro checkNode nodeName>
  <@docker.CONTAINER 'percona-node-checker-${namespace}' 'imagenarium/percona-xtradb-cluster:${PERCONA_VERSION}'>
    <@container.NETWORK 'percona-net-${namespace}' />
    <@container.ENV 'MYSQL_HOST' nodeName />
    <@container.ENTRY '/check_remote.sh' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</#macro>
  
<#if PARAMS.DELETE_DATA == 'true'>
  <@swarm.SERVICE 'percona-init-${namespace}' 'imagenarium/percona-xtradb-cluster:${PERCONA_VERSION}'>
    <@service.NETWORK 'percona-net-${namespace}' />
    <@service.CONSTRAINT 'percona' '1' />
    <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
  </@swarm.SERVICE>
  
  <@checkNode 'percona-init-${namespace}' />
</#if>

<#list PARAMS.RUN_ORDER?split(",") as index>
  <#assign nodes = ["percona-init-${namespace}"] />

  <#list PARAMS.RUN_ORDER?split(",") as _index>
    <#if index != _index>
      <#assign nodes += ["percona-${_index}-${namespace}"] />
    </#if>
  </#list>
    
  <@swarm.SERVICE 'percona-${index}-${namespace}' 'imagenarium/percona-xtradb-cluster:${PERCONA_VERSION}' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
    <@service.NETWORK 'percona-net-${namespace}' />
    <@service.CONSTRAINT 'percona' '${index}' />
    <@service.VOLUME '/var/lib/mysql' />
    <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    <@service.ENV 'CLUSTER_JOIN' nodes?join(",") />
    <@service.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
    <@service.ENV 'GCACHE_SIZE' PARAMS.GCACHE_SIZE />
  </@swarm.SERVICE>
    
  <@checkNode 'percona-${index}-${namespace}' />  
</#list>

<@swarm.SERVICE_RM 'percona-init-${namespace}' />
