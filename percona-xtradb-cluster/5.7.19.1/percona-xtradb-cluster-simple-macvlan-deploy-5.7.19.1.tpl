<@requirement.CONS 'percona' 'master' />
<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />
<@requirement.PARAM name='PUBLISHED_PORT' value='-1' type='number' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' />
<@requirement.PARAM name='MACVLAN_PREFIX' value='10.71' />
<@requirement.PARAM name='MACVLAN_DEVICE' value='ens7.71' />

<@requirement.CONFORMS>
  <#assign PERCONA_VERSION='5.7.19.1' />
  <#assign HAPROXY_VERSION='1.6.7' />
  <#assign NETMASK=PARAMS.MACVLAN_PREFIX />
  
  <#macro checkNode nodeName>
    <@docker.CONTAINER 'percona-node-checker-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@container.NETWORK name='percona-net-overlay-${namespace}' />
      <@container.ENV 'MYSQL_HOST' nodeName />
      <@container.ENTRY '/check_remote.sh' />
      <@container.EPHEMERAL />
    </@docker.CONTAINER>
  </#macro>

  <@swarm.NETWORK 'percona-net-overlay-${namespace}' />
  
  <#if PARAMS.NEW_CLUSTER == 'true'>
    <@swarm.SERVICE 'percona-init-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@service.NETWORK 'percona-net-overlay-${namespace}' />
      <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    </@swarm.SERVICE>
  
    <@checkNode 'percona-init-${namespace}' />
  </#if>

  <#assign nodes = ["percona-init-${namespace}", "percona-master-${namespace}"] />
    
  <@swarm.TASK 'percona-master-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
    <@container.NETWORK 'percona-net-overlay-${namespace}' />
    <@container.NETWORK name='percona-net-macvlan-${namespace}' type='macvlan' macvlan_prefix=PARAMS.MACVLAN_PREFIX macvlan_service_id=1 macvlan_device=PARAMS.MACVLAN_DEVICE />
    <@container.VOLUME 'percona-master-data-volume-${namespace}' '/var/lib/mysql' />
    <@container.VOLUME 'percona-master-log-volume-${namespace}' '/var/log' />
    <@container.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    <@container.ENV 'CLUSTER_JOIN' nodes?join(",") />
    <@container.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
    <@container.ENV 'NETMASK' NETMASK />
    <@introspector.PERCONA />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'percona-master-${namespace}' 'global'>
    <@service.NETWORK 'percona-net-overlay-${namespace}' />
    <@service.CONS 'node.labels.percona' 'master' />
    <@service.ENV 'SERVICE_PORTS' '3306' />
    <@service.ENV 'TCP_PORTS' '3306' />
    <@service.ENV 'BALANCE' 'source' />
    <@service.ENV 'HEALTH_CHECK' 'check port 9200 inter 5000 rise 1 fall 2' />
    <@service.ENV 'OPTION' 'httpchk OPTIONS * HTTP/1.1\\r\\nHost:\\ www' />
  </@swarm.TASK_RUNNER>
    
  <@checkNode 'percona-master-${namespace}' />  

  <@swarm.SERVICE 'percona-proxy-${namespace}' 'dockercloud/haproxy:${HAPROXY_VERSION}'>
    <@service.NETWORK 'percona-net-overlay-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '3306' 'host' />
    <@service.DOCKER_SOCKET />
    <@node.MANAGER />
    <@service.ENV 'EXTRA_GLOBAL_SETTINGS' 'stats socket 0.0.0.0:14567' />
    <@introspector.HAPROXY />
  </@swarm.SERVICE>

  <@swarm.SERVICE_RM 'percona-init-${namespace}' />
</@requirement.CONFORMS>