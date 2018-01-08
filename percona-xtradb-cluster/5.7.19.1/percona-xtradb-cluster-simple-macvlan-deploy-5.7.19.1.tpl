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
  
  <#macro checkNode nodeName>
    <@docker.CONTAINER 'percona-node-checker-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@container.NETWORK name='percona-net-macvlan-${namespace}' type='macvlan' macvlan_prefix=PARAMS.MACVLAN_PREFIX macvlan_service_id=99 macvlan_slot=1 macvlan_device=PARAMS.MACVLAN_DEVICE />
      <@container.ENV 'MYSQL_HOST' nodeName />
      <@container.ENTRY '/check_remote.sh' />
      <@container.EPHEMERAL />
    </@docker.CONTAINER>
  </#macro>
  
  <#if PARAMS.NEW_CLUSTER == 'true'>
    <@swarm.TASK 'percona-init-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}'>
      <@container.NETWORK name='percona-net-macvlan-${namespace}' type='macvlan' macvlan_prefix=PARAMS.MACVLAN_PREFIX macvlan_service_id=42 macvlan_device=PARAMS.MACVLAN_DEVICE />
      <@container.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
      <@container.ENV 'NETMASK' PARAMS.MACVLAN_PREFIX />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'percona-init-${namespace}' />

    <@checkNode '${PARAMS.MACVLAN_PREFIX}.42.1' />
  </#if>

  <#assign nodes = ["${PARAMS.MACVLAN_PREFIX}.42.1", "${PARAMS.MACVLAN_PREFIX}.1.1"] />
    
  <@swarm.TASK 'percona-master-${namespace}' 'imagenarium/percona-master:${PERCONA_VERSION}' '--wsrep_slave_threads=${PARAMS.WSREP_SLAVE_THREADS}'>
    <@container.NETWORK name='percona-net-macvlan-${namespace}' type='macvlan' macvlan_prefix=PARAMS.MACVLAN_PREFIX macvlan_service_id=1 macvlan_device=PARAMS.MACVLAN_DEVICE />
    <@container.VOLUME 'percona-master-data-volume-${namespace}' '/var/lib/mysql' />
    <@container.VOLUME 'percona-master-log-volume-${namespace}' '/var/log' />
    <@container.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    <@container.ENV 'CLUSTER_JOIN' nodes?join(",") />
    <@container.ENV 'XTRABACKUP_USE_MEMORY' '128M' />
    <@container.ENV 'NETMASK' PARAMS.MACVLAN_PREFIX />
    <@introspector.PERCONA />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'percona-master-${namespace}'>
    <@service.CONS 'node.labels.percona' 'master' />
  </@swarm.TASK_RUNNER>
    
  <@checkNode '${PARAMS.MACVLAN_PREFIX}.1.1' />  

  <@swarm.SERVICE_RM 'percona-init-${namespace}' />
</@requirement.CONFORMS>