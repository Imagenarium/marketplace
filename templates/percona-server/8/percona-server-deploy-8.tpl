<@requirement.CONSTRAINT 'percona' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='DB_PARAMS' value='' required='false' type='textarea' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' type='password' />
<@requirement.PARAM name='DEFAULT_DB_NAME' value='testdb' />

<@requirement.PARAM name='PMM_ENABLE' value='false' type='boolean' />
<@requirement.PARAM name='PMM_USER' value='admin' global='true' />
<@requirement.PARAM name='PMM_PASSWORD' value='admin' type='password' global='true' />

<#assign PERCONA_VERSION='8.0' />

<@swarm.SERVICE 'percona-${namespace}' 'imagenarium/percona-server:${PERCONA_VERSION}' PARAMS.DB_PARAMS>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '3306' />
  <@service.CONSTRAINT 'percona' 'true' />
  <@service.VOLUME '/var/lib/mysql' />
  <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
  <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
  <@service.ENV 'MYSQL_DATABASE' PARAMS.DEFAULT_DB_NAME />
  <@service.ENV 'PMM' PARAMS.PMM_ENABLE />
  <@service.ENV 'PMM_USER' PARAMS.PMM_USER />
  <@service.ENV 'PMM_PASSWORD' PARAMS.PMM_PASSWORD />
  <@service.CHECK_PORT '3306' />
</@swarm.SERVICE>
