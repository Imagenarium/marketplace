<@requirement.CONS 'etcd' '1' />
<@requirement.CONS 'etcd' '2' />
<@requirement.CONS 'etcd' '3' />

<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />
<@requirement.PARAM name='ETCD_PORT' type='port' required='false' />
<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-etcd-${namespace}' 'net-${namespace}' />

  <#assign etcd_servers = [] />
  
  <#list 1..3 as index>
    <#assign etcd_servers += ['etcd-${index}-${namespace}=http://etcd-${index}-${namespace}:2380'] />
  </#list>
  
  <#list 1..3 as index>
    <@swarm.SERVICE 'etcd-${index}-${namespace}' 'imagenarium/etcd:latest'>
      <@service.NETWORK 'net-${namespace}' />
      <@service.PORT PARAMS.ETCD_PORT '2379' 'host' />
      <@service.DNSRR />
      <@service.CONS 'node.labels.etcd' '${index}' />
      <@service.VOLUME 'etcd-volume-${index}-${namespace}' '/data' />
      <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-etcd-${namespace}' />
      <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
      <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
      <@service.ENV 'ETCD_INITIAL_CLUSTER' etcd_servers?join(",") />
    </@swarm.SERVICE>
  </#list>

  <@docker.CONTAINER 'etcd-checker-${namespace}' 'imagenarium/etcd:latest'>
    <@container.ENTRY '/checker.sh' />
    <@container.NETWORK 'net-${namespace}' />
    <@container.EPHEMERAL />
    <@container.ENV 'ETCD_HOST' 'etcd-1-${namespace}' />
    <@container.ENV 'EXPECTED_MEMBERS' '${etcd_servers?size}' />
  </@docker.CONTAINER>
</@requirement.CONFORMS>