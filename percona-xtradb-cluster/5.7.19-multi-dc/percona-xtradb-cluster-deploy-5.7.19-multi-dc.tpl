<@requirement.HA />

<@requirement.CONS_HA 'percona' 'master' />

<@requirement.PARAM name='WSREP_SLAVE_THREADS' value='2' type='number' description='Defines the number of threads to use in applying slave write-sets' />
<@requirement.PARAM name='PUBLISHED_PORT' value='-1' type='number' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='RUN_ORDER' value='dc1,dc2,dc3' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' />

<@requirement.CONFORMS>
  <#assign PERCONA_VERSION='5.7.19.2' />
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

  <#list PARAMS.RUN_ORDER?split(",") as orderedDc>  
    <@cloud.DATACENTER ; dc, index, isLast>
      <#if dc == orderedDc>
        <@swarm.NETWORK 'percona-${dc}-${namespace}' />

        <#assign nodes = ["percona-init-${namespace}"] />
   
        <@cloud.DATACENTER ; _dc, _index, _isLast>
          <#if dc != _dc>
            <#assign nodes += ["percona-master-${_dc}-${namespace}"] />
          </#if>
        </@cloud.DATACENTER>
    
        <@swarm.SERVICE 'percona-master-${dc}-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' 'global' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
          <@service.NETWORK 'percona-net-${namespace}' />
          <@service.NETWORK 'percona-${dc}-${namespace}' />
          <@service.DC dc />
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
          <@service.ENV 'GMCAST_SEGMENT' index />
          <@service.ENV 'NETMASK' NETMASK />
          <@introspector.PERCONA />
        </@swarm.SERVICE>
    
        <@checkNode 'percona-master-${dc}-${namespace}' />
  
        <@swarm.SERVICE 'percona-proxy-${dc}-${namespace}' 'dockercloud/haproxy:1.6.7'>
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