<@requirement.CONSTRAINT 'cockroachdb' '1' />
<@requirement.CONSTRAINT 'cockroachdb' '2' />
<@requirement.CONSTRAINT 'cockroachdb' '3' />

<@requirement.PARAM name='PUBLISHED_MANAGER_PORT' type='port' required='false' description='Specify admin external port (for example 5556)' />
<@requirement.PARAM name='MANAGER_PASSWORD' value='$apr1$WqbmakdQ$xqF8YxFcUHtO.X20fjgiJ1' />
<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify CRDB external port (for example 26257)' />
<@requirement.PARAM name='DEFAULT_DB_NAME' value='testdb' />
<@requirement.PARAM name='DB_PARAMS' value='--cache=1GiB --max-sql-memory=1GiB' description='example: --max-sql-memory=25% --cache=25%' type='textarea' />

<#assign COCKROACHDB_VERSION='2.1.6' />
  
<#list 1..3 as index>  
  <#assign nodes = [] />

  <#list 1..3 as _index>
    <#if index != _index>
      <#assign nodes += ['cockroachdb-${_index}-${namespace}:26257'] />    
    </#if>
  </#list>

  <@swarm.SERVICE 'cockroachdb-${index}-${namespace}' 'imagenarium/cockroachdb:${COCKROACHDB_VERSION}' 'start --join=${nodes?join(",")} --host 0.0.0.0 ${PARAMS.DB_PARAMS} --logtostderr --insecure'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '26257' 'host' />
    <@service.CONSTRAINT 'cockroachdb' '${index}' />
    <@service.VOLUME '/cockroach/cockroach-data' />
    <@service.STOP_GRACE_PERIOD '60s' />
    <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
    <@service.ENV 'METRICS_ENDPOINT' ':8080/_status/vars' />
    <@service.CHECK_PATH ':8080/health' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'nginx-cockroachdb-${index}-${namespace}' 'imagenarium/nginx-basic-auth:latest'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_MANAGER_PORT '8080' 'host' />
    <@service.CONSTRAINT 'cockroachdb' '${index}' />
    <@service.ENV 'WEB_USER' 'admin' />
    <@service.ENV 'WEB_PASSWORD' PARAMS.MANAGER_PASSWORD 'single' />
    <@service.ENV 'APP_URL' 'http://cockroachdb-${index}-${namespace}:8080' />
  </@swarm.SERVICE>
</#list>

<#if PARAMS.DELETE_DATA == 'true'>
  <@docker.CONTAINER 'cockroachdb-cluster-initializer-${namespace}' 'cockroachdb/cockroach:v${COCKROACHDB_VERSION}' 'init --host=cockroachdb-1-${namespace} --insecure'>
    <@container.NETWORK 'net-${namespace}' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</#if>

<#list 1..3 as index>
  <@docker.HTTP_CHECKER 'cluster-checker-${namespace}' 'http://cockroachdb-${index}-${namespace}:8080/health?ready=1' 'net-${namespace}' />
</#list>

<#if PARAMS.DELETE_DATA == 'true'>
  <@docker.CONTAINER 'cockroachdb-createdb-${namespace}' 'cockroachdb/cockroach:v${COCKROACHDB_VERSION}' 'sql -e="CREATE DATABASE ${PARAMS.DEFAULT_DB_NAME};" --host=cockroachdb-1-${namespace} --insecure'>
    <@container.NETWORK 'net-${namespace}' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</#if>