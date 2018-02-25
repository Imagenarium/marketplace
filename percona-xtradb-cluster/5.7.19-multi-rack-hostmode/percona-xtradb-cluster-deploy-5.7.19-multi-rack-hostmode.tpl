<@requirement.CONS 'percona' 'rack1' />
<@requirement.CONS 'percona' 'rack2' />
<@requirement.CONS 'percona' 'rack3' />

<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='RUN_ORDER' value='1,2,3' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DATA_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='LOG_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='HOST_INTERFACE' value='eth0' />

<@requirement.CONFORMS>
  <#assign PERCONA_VERSION='5.7.19.6' />
  <#assign HAPROXY_VERSION='1.6.7' />

  <@swarm.NETWORK 'percona-proxy-net-${namespace}' />

  <@swarm.SERVICE 'percona-proxy-${namespace}' 'dockercloud/haproxy:${HAPROXY_VERSION}'>
    <@service.NETWORK 'percona-proxy-net-${namespace}' />
    <@service.PORT '3307' '3306' />
    <@node.MANAGER />
    <@service.ENV 'EXTRA_GLOBAL_SETTINGS' 'stats socket 0.0.0.0:14567' />
    <@introspector.HAPROXY />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECK 'http://stats:stats@percona-proxy-${namespace}:1936' 'percona-proxy-net-${namespace}' />
  
  <#macro checkNode nodeName>
    <@docker.CONTAINER 'percona-node-checker-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@container.NETWORK 'percona-proxy-net-${namespace}' />
      <@container.ENV 'MYSQL_HOST' nodeName />
      <@container.ENTRY '/check_remote.sh' />
      <@container.EPHEMERAL />
    </@docker.CONTAINER>
  </#macro>
  
  <#if PARAMS.NEW_CLUSTER == 'true'>
    <@swarm.TASK 'percona-init-${namespace}'>
      <@container.HOST_NETWORK />
      <@container.ENV 'HOST_INTERFACE' PARAMS.HOST_INTERFACE />
      <@container.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
      <@container.ENV 'MULTICAST' 'true' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'percona-init-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@service.CONS 'node.labels.percona' 'init' />
      <@service.NETWORK 'percona-proxy-net-${namespace}' />
      <@service.ENV 'PROXY_PORTS' '3306,9200' />
      <@service.ENV 'SERVICE_PORTS' '3306' />
      <@service.ENV 'TCP_PORTS' '3306' />
      <@service.ENV 'BALANCE' 'source' />
      <@service.ENV 'HEALTH_CHECK' 'check port 9200 inter 5000 rise 1 fall 2' />
      <@service.ENV 'OPTION' 'httpchk OPTIONS * HTTP/1.1\\r\\nHost:\\ www' />
    </@swarm.TASK_RUNNER>

    <@checkNode 'percona-init-${namespace}' />
  </#if>

  <#list PARAMS.RUN_ORDER?split(",") as rack>
    <#assign nodes = ["127.0.0.1"] />
    
    <@swarm.TASK 'percona-master-rack${rack}-${namespace}'>
      <@container.HOST_NETWORK />
      <@container.VOLUME 'percona-master-data-volume-rack${rack}-${namespace}' '/var/lib/mysql' PARAMS.VOLUME_DRIVER PARAMS.DATA_VOLUME_OPTS?trim />
      <@container.VOLUME 'percona-master-log-volume-rack${rack}-${namespace}' '/var/log' PARAMS.VOLUME_DRIVER PARAMS.LOG_VOLUME_OPTS?trim />
      <@container.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
      <@container.ENV 'CLUSTER_JOIN' nodes?join(",") />
      <@container.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
      <@container.ENV 'HOST_INTERFACE' PARAMS.HOST_INTERFACE />
      <@container.ENV 'MULTICAST' 'true' />
      <@container.ENV 'DISCOVER_PORT' '3307' />
      <@introspector.PERCONA />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'percona-master-rack${rack}-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
      <@service.CONS 'node.labels.percona' 'rack${rack}' />
      <@service.NETWORK 'percona-proxy-net-${namespace}' />
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
</@requirement.CONFORMS>