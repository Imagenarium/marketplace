<@requirement.CONS 'cockroachdb' '1' />
<@requirement.CONS 'cockroachdb' '2' />
<@requirement.CONS 'cockroachdb' '3' />

<@requirement.PARAM name='PUBLISHED_MANAGER_PORT' value='5556' type='port' />
<@requirement.PARAM name='PUBLISHED_PORT' value='26257' type='port' required='false' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='NETWORK_DRIVER' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='cockroach-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />
  
  <@swarm.STORAGE 'swarmstorage-cockroach-${namespace}' 'cockroach-net-${namespace}' />
  
  <#list 1..3 as index>  
    <#assign nodes = [] />

    <#list 1..3 as _index>
      <#if index != _index>
        <#assign nodes += ['cockroachdb-${_index}-${namespace}:26257'] />    
      </#if>
    </#list>

    <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
      <@swarm.VOLUME_RM 'cockroach-volume-${index}-${namespace}' />
    </#if>

    <@swarm.SERVICE 'cockroachdb-${index}-${namespace}' 'imagenarium/cockroachdb:2.0.1' 'replicated' 'start --join=${nodes?join(",")} --host 0.0.0.0 --cache=.25 --max-sql-memory=.25 --logtostderr --insecure'>
      <@service.NETWORK 'cockroach-net-${namespace}' />
      <@service.PORT PARAMS.PUBLISHED_PORT '26257' 'host' />
      <@service.PORT PARAMS.PUBLISHED_MANAGER_PORT '8080' 'host' />
      <@service.HOSTNAME 'cockroachdb-${index}-${namespace}' />      
      <@service.CONS 'node.labels.cockroachdb' '${index}' />
      <@service.VOLUME 'cockroach-volume-${index}-${namespace}' '/cockroach/cockroach-data' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, 1) />
      <@service.STOP_GRACE_PERIOD '60s' />
      <@service.ENV 'NETWORK_NAME' 'cockroach-net-${namespace}' />
      <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@service.ENV 'VOLUME_DRIVER' PARAMS.VOLUME_DRIVER />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-cockroach-${namespace}' />
    </@swarm.SERVICE>

    <@docker.HTTP_CHECKER 'cockroach-checker-${namespace}' 'http://cockroachdb-${index}-${namespace}:8080' 'cockroach-net-${namespace}' />
  </#list>

  <#if PARAMS.DELETE_DATA == 'true'>
    <@docker.CONTAINER 'cockroachdb-cluster-initializer-${namespace}' 'cockroachdb/cockroach:v2.0.1' 'init --host=cockroachdb-1-${namespace} --insecure'>
      <@container.NETWORK 'cockroach-net-${namespace}' />
      <@container.EPHEMERAL />
    </@docker.CONTAINER>
  </#if>
</@requirement.CONFORMS>
