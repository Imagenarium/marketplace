<@requirement.CONS 'percona' 'rack1' />
<@requirement.CONS 'percona' 'rack2' />
<@requirement.CONS 'percona' 'rack3' />

<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />
<@requirement.PARAM name='PUBLISHED_PORT' value='-1' type='number' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='RUN_ORDER' value='1,2,3' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DATA_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='LOG_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='MULTICAST' value='false' type='boolean' />

<@requirement.CONFORMS>
  <#assign PERCONA_VERSION='5.7.19.6' />
  <#assign HAPROXY_VERSION='1.6.7' />
  
  <#macro checkNode nodeName>
    <@docker.CONTAINER 'percona-node-checker-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@container.NETWORK 'percona-net-${namespace}' />
      <@container.ENV 'MYSQL_HOST' nodeName />
      <@container.ENTRY '/check_remote.sh' />
      <@container.EPHEMERAL />
    </@docker.CONTAINER>
  </#macro>

  <@swarm.NETWORK name='percona-net-${namespace}' subnet='${RANDOM_NET_PREFIX_24}.0/24' driver='weave:latest' />
  
  <#if PARAMS.DELETE_DATA == 'true'>
    <@swarm.TASK 'percona-init-${namespace}'>
      <@container.NETWORK 'percona-net-${namespace}' />
      <@container.ENV 'NET_PREFIX' RANDOM_NET_PREFIX_24 />
      <@container.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
      <@container.ENV 'MULTICAST' PARAMS.MULTICAST />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'percona-init-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' />

    <@checkNode 'percona-init-${namespace}.1' />
  </#if>

  <#list PARAMS.RUN_ORDER?split(",") as rack>
    <#assign nodes = ["percona-init-${namespace}.1"] />

    <#list PARAMS.RUN_ORDER?split(",") as _rack>
      <#if rack != _rack>
        <#assign nodes += ["percona-master-rack${_rack}-${namespace}"] />
      </#if>
    </#list>
    
    <@swarm.TASK 'percona-master-rack${rack}-${namespace}'>
      <@container.NETWORK name='percona-net-${namespace}' />
      <@container.VOLUME 'percona-master-data-volume-rack${rack}-${namespace}' '/var/lib/mysql' PARAMS.VOLUME_DRIVER PARAMS.DATA_VOLUME_OPTS?trim />
      <@container.VOLUME 'percona-master-log-volume-rack${rack}-${namespace}' '/var/log' PARAMS.VOLUME_DRIVER PARAMS.LOG_VOLUME_OPTS?trim />
      <@container.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
      <@container.ENV 'CLUSTER_JOIN' nodes?join(",") />
      <@container.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
      <@container.ENV 'NET_PREFIX' RANDOM_NET_PREFIX_24 />
      <@container.ENV 'MULTICAST' PARAMS.MULTICAST />
      <@introspector.PERCONA />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'percona-master-rack${rack}-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
      <@service.CONS 'node.labels.percona' 'rack${rack}' />
      <@service.NETWORK 'percona-net-${namespace}' />
      <@service.ENV 'PROXY_PORTS' '3306,9200' />
      <@service.ENV 'SERVICE_PORTS' '3306' />
      <@service.ENV 'TCP_PORTS' '3306' />
      <@service.ENV 'BALANCE' 'source' />
      <@service.ENV 'HEALTH_CHECK' 'check port 9200 inter 5000 rise 1 fall 2' />
      <@service.ENV 'OPTION' 'httpchk OPTIONS * HTTP/1.1\\r\\nHost:\\ www' />
    </@swarm.TASK_RUNNER>

    <@checkNode 'percona-master-rack${rack}-${namespace}' />
  </#list>

  <@swarm.SERVICE_RM 'percona-init-${namespace}' />

  <@swarm.SERVICE 'percona-proxy-${namespace}' 'dockercloud/haproxy:${HAPROXY_VERSION}'>
    <@service.NETWORK 'percona-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '3306' 'host' />
    <@node.MANAGER />
    <@service.ENV 'EXTRA_GLOBAL_SETTINGS' 'stats socket 0.0.0.0:14567' />
    <@introspector.HAPROXY />
  </@swarm.SERVICE>
</@requirement.CONFORMS>