<@requirement.CONSTRAINT 'sentinel' '1' />
<@requirement.CONSTRAINT 'sentinel' '2' />
<@requirement.CONSTRAINT 'sentinel' '3' />
<@requirement.CONSTRAINT 'keeper' '1' />
<@requirement.CONSTRAINT 'keeper' '2' />
<@requirement.CONSTRAINT 'keeper' '3' />
<@requirement.CONSTRAINT 'proxy' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />
<@requirement.PARAM name='POSTGRES_USER' value='postgres' />
<@requirement.PARAM name='POSTGRES_PASSWORD' value='postgres' />
<@requirement.PARAM name='POSTGRES_PARAMS' value='\"max_connections\":\"1000\",\"shared_buffers\":\"1GB\"' type='textarea' />

<@requirement.PARAM name='APP_USER' value='app' />
<@requirement.PARAM name='APP_PASSWORD' value='app' />

<@requirement.PARAM name='PMM_ENABLE' value='false' type='boolean' />
<@requirement.PARAM name='PMM_USER' value='admin' scope='global' />
<@requirement.PARAM name='PMM_PASSWORD' value='admin' type='password' scope='global' />

<#if PARAMS.DELETE_DATA == 'true'>
  <@docker.CONTAINER 'stolon-init-${namespace}' 'imagenarium/stolon:pg11'>
    <@container.NETWORK 'net-${namespace}' />
    <@container.ENV 'ROLE' 'INIT' />
    <@container.ENV 'POSTGRES_PARAMS' PARAMS.POSTGRES_PARAMS />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</#if>

<#list 1..3 as index>
  <@swarm.SERVICE 'stolon-sentinel-${index}-${namespace}' 'imagenarium/stolon:pg11'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.CONSTRAINT 'sentinel' '${index}' />
    <@service.ENV 'ROLE' 'SENTINEL' />
    <@service.CHECK_PORT '8585' />
  </@swarm.SERVICE>
</#list>

<#list 1..3 as index>
  <@img.TASK 'stolon-keeper-${index}-${namespace}' 'imagenarium/stolon:pg11'>
    <@img.NETWORK 'net-${namespace}' />
    <@img.VOLUME '/var/lib/postgresql/data' />
    <@img.BIND '/sys/kernel/mm/transparent_hugepage' '/tph' />
    <@img.CONSTRAINT 'keeper' '${index}' />
    <@img.ENV 'ROLE' 'KEEPER' />
    <@img.ENV 'KEEPER_ID' '${index}' />
    <@img.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
    <@img.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
    <@img.ENV 'NETWORK_NAME' 'net-${namespace}' />

    <@img.ENV 'PMM' PARAMS.PMM_ENABLE />
    <@img.ENV 'PMM_USER' PARAMS.PMM_USER />
    <@img.ENV 'PMM_PASSWORD' PARAMS.PMM_PASSWORD />
  </@img.TASK>
</#list>

<#list 1..3 as index>
  <@docker.TCP_CHECKER 'cluster-checker-${namespace}' 'stolon-keeper-${index}-${namespace}:5432' 'net-${namespace}' />
</#list>

<@swarm.SERVICE 'stolon-proxy-${namespace}' 'imagenarium/stolon:pg11'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5432' />
  <@service.VOLUME '/tmp' />
  <@service.CONSTRAINT 'proxy' 'true' />
  <@service.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
  <@service.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
  <@service.ENV 'APP_USER' PARAMS.APP_USER />
  <@service.ENV 'APP_PASSWORD' PARAMS.APP_PASSWORD />
  <@service.ENV 'ROLE' 'PROXY' />
  <@service.CHECK_PORT '5432' />
</@swarm.SERVICE>