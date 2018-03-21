<@requirement.CONS 'percona' '1' />
<@requirement.CONS 'percona' '2' />
<@requirement.CONS 'percona' '3' />

<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />
<@requirement.PARAM name='PUBLISHED_PORT' value='-1' type='number' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='RUN_ORDER' value='1,2,3' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' type='password' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <#assign PERCONA_VERSION='5.7.21' />
  <#assign HAPROXY_VERSION='1.6.7' />
  
  <#macro checkNode nodeName>
    <@docker.CONTAINER 'percona-node-checker-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@container.NETWORK 'percona-net-${namespace}' />
      <@container.ENV 'MYSQL_HOST' nodeName />
      <@container.ENTRY '/check_remote.sh' />
      <@container.EPHEMERAL />
    </@docker.CONTAINER>
  </#macro>
  
  <@swarm.NETWORK name='percona-net-${namespace}' subnet='${RANDOM_NET_PREFIX_24}.0/24' driver=PARAMS.NETWORK_DRIVER />

  <#if PARAMS.DELETE_DATA == 'true'>
    <@swarm.SERVICE 'percona-init-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@service.HOSTNAME 'percona-init-${namespace}' />
      <@service.NETWORK 'percona-net-${namespace}' />
      <@service.ENV 'NET_PREFIX' RANDOM_NET_PREFIX_24 />
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

    <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
      <@swarm.VOLUME_RM 'percona-volume-${index}-${namespace}' />
    </#if>
    
    <@swarm.SERVICE 'percona-${index}-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' 'replicated' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
      <@service.HOSTNAME 'percona-${index}-${namespace}' />
      <@service.NETWORK 'percona-net-${namespace}' />
      <@service.CONS 'node.labels.percona' '${index}' />
      <@service.VOLUME 'percona-volume-${index}-${namespace}' '/var/lib/mysql' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, PARAMS.VOLUME_SIZE_GB) />
      <@service.ENV 'SERVICE_PORTS' '3306' />
      <@service.ENV 'TCP_PORTS' '3306' />
      <@service.ENV 'BALANCE' 'source' />
      <@service.ENV 'HEALTH_CHECK' 'check port 9200 inter 5000 rise 1 fall 2' />
      <@service.ENV 'OPTION' 'httpchk OPTIONS * HTTP/1.1\\r\\nHost:\\ www' />
      <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
      <@service.ENV 'CLUSTER_JOIN' nodes?join(",") />
      <@service.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
      <@service.ENV 'NET_PREFIX' RANDOM_NET_PREFIX_24 />
    </@swarm.SERVICE>
    
    <@checkNode 'percona-${index}-${namespace}' />  
  </#list>

  <@swarm.SERVICE 'percona-proxy-${namespace}' 'dockercloud/haproxy:${HAPROXY_VERSION}'>
    <@service.NETWORK 'percona-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '3306' 'host' />
    <@node.MANAGER />
    <@service.ENV 'EXTRA_GLOBAL_SETTINGS' 'stats socket 0.0.0.0:14567' />
  </@swarm.SERVICE>

  <@swarm.SERVICE_RM 'percona-init-${namespace}' />
</@requirement.CONFORMS>