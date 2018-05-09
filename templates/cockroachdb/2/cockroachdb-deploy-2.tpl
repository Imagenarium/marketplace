<@requirement.CONS 'cockroachdb' '1' />
<@requirement.CONS 'cockroachdb' '2' />
<@requirement.CONS 'cockroachdb' '3' />

<@requirement.PARAM name='PUBLISHED_MANAGER_PORT' value='8888' type='port' />
<@requirement.PARAM name='PUBLISHED_PORT' value='26257' type='port' required='false' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='NETWORK_DRIVER' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='cockroach-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />
  
  <#assign nodes = [] />
  <#list 1..3 as index>
    <#assign nodes += ['cockroachdb-${index}-${namespace}:26257'] />    
  </#list>
 
  <@swarm.STORAGE 'swarmstorage-cockroach-${namespace}' 'cockroach-net-${namespace}' />
  
  <#list 1..3 as index>
    <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
      <@swarm.VOLUME_RM 'cockroach-volume-${index}-${namespace}' />
    </#if>

    <@swarm.SERVICE 'cockroachdb-${index}-${namespace}' 'imagenarium/cockroachdb:2.0.1' 'replicated' 'start --join=${nodes?join(",")} --cache=.25 --max-sql-memory=.25 --logtostderr --insecure'>
      <@service.NETWORK 'cockroach-net-${namespace}' />
      <@service.PORT PARAMS.PUBLISHED_PORT '26257' 'host' />
      <@service.PORT PARAMS.PUBLISHED_MANAGER_PORT '8080' 'host' />
      <@service.HOSTNAME 'cockroachdb-${index}-${namespace}' />      
      <@service.CONS 'node.labels.cockroachdb' '${index}' />
      <@service.VOLUME 'cockroach-volume-${index}-${namespace}' '/cockroach/cockroach-data' PARAMS.VOLUME_DRIVER docker.VOLUME_SIZE(PARAMS.VOLUME_DRIVER, 1) />
      <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@service.ENV 'VOLUME_DRIVER' PARAMS.VOLUME_DRIVER />
      <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-cockroach-${namespace}' />
      --stop-grace-period 60s \
    </@swarm.SERVICE>
  </#list>

  <@docker.HTTP_CHECKER 'cockroach-checker-${namespace}' 'http://cockroachdb-3-${namespace}:8080' 'cockroach-net-${namespace}' />
</@requirement.CONFORMS>
