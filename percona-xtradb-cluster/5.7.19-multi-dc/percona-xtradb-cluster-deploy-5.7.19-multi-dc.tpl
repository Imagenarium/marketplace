<@requirement.HA />

<@requirement.CONS_HA 'percona' 'master' />

<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />
<@requirement.PARAM name='PUBLISHED_PORT' value='-1' type='number' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='RUN_ORDER' value='dc1,dc2,dc3' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='DATA_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='LOG_VOLUME_OPTS' value=' ' />

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
  
  <@swarm.NETWORK name='percona-net-${namespace}' subnet='${RANDOM_NET_PREFIX_24}.0/24' driver=PARAMS.NETWORK_DRIVER />

  <#if PARAMS.DELETE_DATA == 'true'>
    <@swarm.SERVICE 'percona-init-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@service.HOSTNAME 'percona-init-${namespace}' />
      <@service.NETWORK 'percona-net-${namespace}' />
      <@service.ENV 'NETWORK_NAME' 'percona-net-${namespace}' />
      <@service.ENV 'NET_PREFIX' RANDOM_NET_PREFIX_24 />
      <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    </@swarm.SERVICE>
  
    <@checkNode 'percona-init-${namespace}' />
  </#if>

  <#list PARAMS.RUN_ORDER?split(",") as orderedDc>  
    <@cloud.DATACENTER ; dc, index, isLast>
      <#if dc == orderedDc>
        <@swarm.NETWORK name='percona-${dc}-${namespace}' driver=PARAMS.NETWORK_DRIVER />

        <#assign nodes = ["percona-init-${namespace}"] />
   
        <@cloud.DATACENTER ; _dc, _index, _isLast>
          <#if dc != _dc>
            <#assign nodes += ["percona-master-${_dc}-${namespace}"] />
          </#if>
        </@cloud.DATACENTER>
    
        <@swarm.SERVICE 'percona-master-${dc}-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' 'replicated' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
          <@service.HOSTNAME 'percona-master-${dc}-${namespace}' />
          <@service.NETWORK 'percona-net-${namespace}' />
          <@service.NETWORK 'percona-${dc}-${namespace}' />
          <@service.DC dc />
          <@service.CONS 'node.labels.percona' 'master' />
          <@service.VOLUME 'percona-master-data-volume-${dc}-${namespace}' '/var/lib/mysql' PARAMS.VOLUME_DRIVER PARAMS.DATA_VOLUME_OPTS?trim />
          <@service.VOLUME 'percona-master-log-volume-${dc}-${namespace}' '/var/log' PARAMS.VOLUME_DRIVER PARAMS.LOG_VOLUME_OPTS?trim />
          <@service.ENV 'SERVICE_PORTS' '3306' />
          <@service.ENV 'TCP_PORTS' '3306' />
          <@service.ENV 'BALANCE' 'source' />
          <@service.ENV 'HEALTH_CHECK' 'check port 9200 inter 5000 rise 1 fall 2' />
          <@service.ENV 'OPTION' 'httpchk OPTIONS * HTTP/1.1\\r\\nHost:\\ www' />
          <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
          <@service.ENV 'CLUSTER_JOIN' nodes?join(",") />
          <@service.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
          <@service.ENV 'GMCAST_SEGMENT' '${index}' />
          <@service.ENV 'NET_PREFIX' RANDOM_NET_PREFIX_24 />
          <@introspector.PERCONA />
        </@swarm.SERVICE>
    
        <@checkNode 'percona-master-${dc}-${namespace}' />
  
        <@swarm.SERVICE 'percona-proxy-${dc}-${namespace}' 'dockercloud/haproxy:${HAPROXY_VERSION}'>
          <@service.NETWORK 'percona-${dc}-${namespace}' />
          <@service.PORT PARAMS.PUBLISHED_PORT '3306' 'host' />
          <@node.MANAGER />
          <@service.DC dc />
          <@service.ENV 'EXTRA_GLOBAL_SETTINGS' 'stats socket 0.0.0.0:14567' />
          <@introspector.HAPROXY />
        </@swarm.SERVICE>
      </#if>
    </@cloud.DATACENTER>
  </#list>  
  <@swarm.SERVICE_RM 'percona-init-${namespace}' />
</@requirement.CONFORMS>