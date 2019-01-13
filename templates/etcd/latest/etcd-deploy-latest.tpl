<@requirement.CONSTRAINT 'etcd' '1' />
<@requirement.CONSTRAINT 'etcd' '2' />
<@requirement.CONSTRAINT 'etcd' '3' />

<@requirement.PARAM name='ETCD_PORT' type='port' required='false' />

<#assign etcd_servers = [] />
  
<#list 1..3 as index>
  <#assign etcd_servers += ['etcd-${index}-${namespace}=http://etcd-${index}-${namespace}:2380'] />
</#list>
  
<#list 1..3 as index>
  <@swarm.SERVICE 'etcd-${index}-${namespace}' 'imagenarium/etcd:latest'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.PORT PARAMS.ETCD_PORT '2379' 'host' />
    <@service.DNSRR />
    <@service.CONSTRAINT 'etcd' '${index}' />
    <@service.VOLUME '/data' />
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
