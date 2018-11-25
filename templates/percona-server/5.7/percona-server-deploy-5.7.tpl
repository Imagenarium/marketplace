<@requirement.CONSTRAINT 'percona' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='PMM_PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='DB_PARAMS' value='' required='false' type='textarea' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' type='password' />
<@requirement.PARAM name='DEFAULT_DB_NAME' value='testdb' />

<#assign PERCONA_VERSION='5.7.23_2' />
    
<@swarm.SERVICE 'pmm-${namespace}' 'imagenarium/pmm:latest'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.PMM_PUBLISHED_PORT '80' />
  <@service.CONSTRAINT 'percona' 'true' />
  <@service.VOLUME '/opt/prometheus/data' />
  <@service.VOLUME '/opt/consul-data' />
  <@service.VOLUME '/var/lib/mysql' />
  <@service.VOLUME '/var/lib/grafana' />
</@swarm.SERVICE>

<@docker.HTTP_CHECKER 'pmm-checker-${namespace}' 'http://pmm-${namespace}:80/graph' 'net-${namespace}' />

<@swarm.SERVICE 'percona-${namespace}' 'imagenarium/percona-server:${PERCONA_VERSION}' PARAMS.DB_PARAMS>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '3306' />
  <@service.CONSTRAINT 'percona' 'true' />
  <@service.VOLUME '/var/lib/mysql' />
  <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
  <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
  <@service.ENV 'MYSQL_DATABASE' PARAMS.DEFAULT_DB_NAME />
</@swarm.SERVICE>
    
<@docker.TCP_CHECKER 'percona-checker-${namespace}' 'percona-${namespace}:3306' 'net-${namespace}' />
