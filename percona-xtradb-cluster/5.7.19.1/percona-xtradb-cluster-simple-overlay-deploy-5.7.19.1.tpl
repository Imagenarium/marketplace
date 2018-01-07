<@requirement.CONS 'percona' 'master' />
<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />
<@requirement.PARAM name='PUBLISHED_PORT' value='-1' type='number' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' />

<@requirement.CONFORMS>
  <#assign PERCONA_VERSION='5.7.19.1' />
  <#assign HAPROXY_VERSION='1.6.7' />
  <#assign NETMASK=randomNetmask24 />
  
  <#macro checkNode nodeName>
    <@docker.CONTAINER 'percona-node-checker-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@container.NETWORK 'percona-net-${namespace}' />
      <@container.ENV 'MYSQL_HOST' nodeName />
      <@container.ENTRY '/check_remote.sh' />
      <@container.EPHEMERAL />
    </@docker.CONTAINER>
  </#macro>
  
  <@swarm.NETWORK 'percona-net-${namespace}' '${NETMASK}.0/24' />

  <#if PARAMS.NEW_CLUSTER == 'true'>
    <@swarm.SERVICE 'percona-init-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@service.NETWORK 'percona-net-${namespace}' />
      <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    </@swarm.SERVICE>
  
    <@checkNode 'percona-init-${namespace}' />
  </#if>

  <#assign nodes = ["percona-init-${namespace}", "percona-master-${namespace}"] />
    
  <@swarm.SERVICE 'percona-master-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' 'global' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
    <@service.NETWORK 'percona-net-${namespace}' />
    <@service.CONS 'node.labels.percona' 'master' />
    <@service.VOLUME 'percona-master-data-volume-${namespace}' '/var/lib/mysql' />
    <@service.VOLUME 'percona-master-log-volume-${namespace}' '/var/log' />
    <@service.ENV 'SERVICE_PORTS' '3306' />
    <@service.ENV 'TCP_PORTS' '3306' />
    <@service.ENV 'BALANCE' 'source' />
    <@service.ENV 'HEALTH_CHECK' 'check port 9200 inter 5000 rise 1 fall 2' />
    <@service.ENV 'OPTION' 'httpchk OPTIONS * HTTP/1.1\\r\\nHost:\\ www' />
    <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    <@service.ENV 'CLUSTER_JOIN' nodes?join(",") />
    <@service.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
    <@service.ENV 'NETMASK' NETMASK />
    <@introspector.PERCONA />
  </@swarm.SERVICE>
    
  <@checkNode 'percona-master-${namespace}' />  

  <@swarm.SERVICE 'percona-proxy-${namespace}' 'dockercloud/haproxy:${HAPROXY_VERSION}'>
    <@service.NETWORK 'percona-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '3306' 'host' />
    <@service.DOCKER_SOCKET />
    <@node.MANAGER />
    <@service.ENV 'EXTRA_GLOBAL_SETTINGS' 'stats socket 0.0.0.0:14567' />
    <@introspector.HAPROXY />
  </@swarm.SERVICE>

  <@swarm.SERVICE_RM 'percona-init-${namespace}' />
</@requirement.CONFORMS>