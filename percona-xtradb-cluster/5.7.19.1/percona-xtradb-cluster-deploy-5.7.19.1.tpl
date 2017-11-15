<@requirement.HA />
<@requirement.SECRET 'mysql_root_password' />
<@requirement.CONS 'percona' 'master' />
<@requirement.PARAM 'uniqueId' />
<@requirement.PARAM 'wsrepSlaveThreads' '2' />
<@requirement.PARAM 'proxyPort' '-1' />

<@requirement.CONFORMS>
  <#assign PERCONA_VERSION='5.7.19.1' />
  <#assign HAPROXY_VERSION='1.6.7' />
  <#assign NET_MASK=randomNetmask24 />
  
  <#macro checkNode nodeName>
    <@docker.CONTAINER 'percona-node-checker-${uniqueId}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@container.NETWORK 'percona-net-${uniqueId}' />
      <@container.ENV 'MYSQL_HOST' nodeName />
      <@container.ENTRY '/check_remote.sh' />
      <@container.EPHEMERAL />
    </@docker.CONTAINER>
  </#macro>
  
  <@swarm.NETWORK 'monitoring' />
  <@swarm.NETWORK 'haproxy-monitoring' />
  <@swarm.NETWORK 'percona-net-${uniqueId}' '${NET_MASK}.0/24' />
  
  <@swarm.SERVICE 'percona-init-${uniqueId}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
    <@service.NETWORK 'percona-net-${uniqueId}' />
    <@service.SECRET 'mysql_root_password' />
    <@service.ENV 'MYSQL_ROOT_PASSWORD_FILE' '/run/secrets/mysql_root_password' />
    <@service.VOLUME 'percona-init-log-volume-${randomUuid}' '/var/log' />
  </@swarm.SERVICE>
  
  <@checkNode 'percona-init-${uniqueId}' />
  
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.NETWORK 'percona-${dc}-${uniqueId}' />
    
    <#assign nodes = ["percona-init-${uniqueId}"] />
   
    <@cloud.DATACENTER ; _dc, _index, _isLast>
      <#if dc != _dc>
        <#assign nodes += ["percona-master-${_dc}-${uniqueId}"] />
      </#if>
    </@cloud.DATACENTER>
    
    <@swarm.SERVICE 'percona-master-${dc}-${uniqueId}' 'imagenarium/percona-master:${PERCONA_VERSION}' 'global' '--wsrep_slave_threads=${PARAMS.wsrepSlaveThreads}'>
      <@service.NETWORK 'monitoring' />
      <@service.NETWORK 'percona-net-${uniqueId}' />
      <@service.NETWORK 'percona-${dc}-${uniqueId}' />
      <@service.SECRET 'mysql_root_password' />
      <@service.DC dc />
      <@service.CONS 'node.labels.percona' 'master' />
      <#-- Using randomUuid to avoid stale data volumes when replicas count > 1  -->
      <@service.VOLUME 'percona-master-data-volume-${randomUuid}' '/var/lib/mysql' />
      <@service.VOLUME 'percona-master-log-volume-${randomUuid}' '/var/log' />
      <@service.ENV 'SERVICE_PORTS' '3306' />
      <@service.ENV 'TCP_PORTS' '3306' />
      <@service.ENV 'BALANCE' 'source' />
      <@service.ENV 'HEALTH_CHECK' 'check port 9200 inter 5000 rise 1 fall 2' />
      <@service.ENV 'OPTION' 'httpchk OPTIONS * HTTP/1.1\\r\\nHost:\\ www' />
      <@service.ENV 'MYSQL_ROOT_PASSWORD_FILE' '/run/secrets/mysql_root_password' />
      <@service.ENV 'CLUSTER_JOIN' nodes?join(",") />
      <@service.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
      <@service.ENV 'GMCAST_SEGMENT' index />
      <@service.ENV 'NETMASK' NET_MASK />
      <@service.ENV 'INTROSPECT_PORT' '3306' />
      <@service.ENV 'INTROSPECT_PROTOCOL' 'mysql' />
      <@service.ENV 'INTROSPECT_MYSQL_USER' 'healthchecker' />
      <@service.ENV '1INTROSPECT_STATUS' 'wsrep_cluster_status' />
      <@service.ENV '2INTROSPECT_STATUS_LONG' 'wsrep_cluster_size' />
      <@service.ENV '3INTROSPECT_STATUS_LONG' 'wsrep_local_state' />
      <@service.ENV '4INTROSPECT_STATUS_LONG' 'wsrep_local_recv_queue' />
      <@service.ENV '5INTROSPECT_STATUS_LONG' 'wsrep_local_send_queue' />
      <@service.ENV '6INTROSPECT_STATUS_LONG' 'wsrep_received_bytes' />
      <@service.ENV '7INTROSPECT_STATUS_LONG' 'wsrep_replicated_bytes' />
      <@service.ENV '8INTROSPECT_STATUS_LONG' 'wsrep_flow_control_recv' />
      <@service.ENV '9INTROSPECT_STATUS_LONG' 'wsrep_flow_control_sent' />
      <@service.ENV '10INTROSPECT_STATUS_LONG' 'wsrep_flow_control_paused_ns' />
      <@service.ENV '11INTROSPECT_STATUS_LONG' 'wsrep_local_commits' />
      <@service.ENV '12INTROSPECT_STATUS_LONG' 'wsrep_local_bf_aborts' />
      <@service.ENV '13INTROSPECT_STATUS_LONG' 'wsrep_local_cert_failures' />
      <@service.ENV '14INTROSPECT_STATUS' 'wsrep_local_state_comment' />
      <@service.ENV '15INTROSPECT_VARIABLE' 'server_id' />
    </@swarm.SERVICE>
    
    <@checkNode 'percona-master-${dc}-${uniqueId}' />
  
    <@swarm.SERVICE 'percona-proxy-${dc}-${uniqueId}' 'dockercloud/haproxy:${HAPROXY_VERSION}'>
      <@service.NETWORK 'haproxy-monitoring' />
      <@service.NETWORK 'percona-${dc}-${uniqueId}' />
      <@service.PORT PARAMS.proxyPort '3306' 'host' />
      <@service.DOCKER_SOCKET />
      <@node.MANAGER />
      <@service.DC dc />
      <@service.ENV 'EXTRA_GLOBAL_SETTINGS' 'stats socket 0.0.0.0:14567' />
      <@service.ENV 'INTROSPECT_PORT' '14567' />
      <@service.ENV 'INTROSPECT_PROTOCOL' 'haproxy' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
  
  <@swarm.SERVICE_RM 'percona-init-${uniqueId}' />
</@requirement.CONFORMS>