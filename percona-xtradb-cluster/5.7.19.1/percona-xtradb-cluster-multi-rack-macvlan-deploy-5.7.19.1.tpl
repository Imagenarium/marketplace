<@requirement.CONS 'percona' 'rack1' />
<@requirement.CONS 'percona' 'rack2' />
<@requirement.CONS 'percona' 'rack3' />
<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />
<@requirement.PARAM name='PUBLISHED_PORT' value='-1' type='number' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' />
<@requirement.PARAM name='MACVLAN_PREFIX' value='10.71' />
<@requirement.PARAM name='MACVLAN_DEVICE' value='ens7.71' />
<@requirement.PARAM name='RUN_ORDER' value='rack1,rack2,rack3' />

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

  <#list PARAMS.RUN_ORDER?split(",") as rack>
    <#assign nodes = ["percona-init-${namespace}"] />

    <#list PARAMS.RUN_ORDER?split(",") as _rack>
      <#if rack != _rack>
        <#assign nodes += ["percona-master-${_rack}-${namespace}"] />
      </#if>
    </#list>
    
    <@swarm.TASK 'percona-master-${rack}-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
      <@container.NETWORK 'percona-net-overlay-${namespace}' />
      <@container.NETWORK name='percona-net-macvlan-${namespace}' type='macvlan' macvlan_prefix=PARAMS.MACVLAN_PREFIX macvlan_service_id=rack?counter macvlan_device=PARAMS.MACVLAN_DEVICE />
      <@container.VOLUME 'percona-master-data-volume-${namespace}' '/var/lib/mysql' />
      <@container.VOLUME 'percona-master-log-volume-${namespace}' '/var/log' />
      <@container.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
      <@container.ENV 'CLUSTER_JOIN' nodes?join(",") />
      <@container.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
      <@container.ENV 'NETMASK' NETMASK />
      <@introspector.PERCONA />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'percona-master-${rack}-${namespace}'>
      <@service.NETWORK 'percona-net-overlay-${namespace}' />
      <@service.CONS 'node.labels.percona' rack />
      <@service.ENV 'SERVICE_PORTS' '3306' />
      <@service.ENV 'TCP_PORTS' '3306' />
      <@service.ENV 'BALANCE' 'source' />
      <@service.ENV 'HEALTH_CHECK' 'check port 9200 inter 5000 rise 1 fall 2' />
      <@service.ENV 'OPTION' 'httpchk OPTIONS * HTTP/1.1\\r\\nHost:\\ www' />
    </@swarm.TASK_RUNNER>
    
    <@checkNode 'percona-master-${rack}-${namespace}' />  
  </#list>

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