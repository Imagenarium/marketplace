<@requirement.CONS 'percona' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='PMM_PUBLISHED_PORT' type='port' required='false' />
<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />
<@requirement.PARAM name='DB_PARAMS' value='--innodb-log-file-size=1G --innodb-buffer-pool-size=5G --innodb-flush-log-at-trx-commit=1 --sync-binlog=1 --query-cache-type=0 --log-output=file --slow-query-log=ON --long-query-time=0 --log-slow-rate-limit=100 --log-slow-rate-type=query --log-slow-verbosity=full --slow-query-log-always-write-time=1 --slow-query-log-use-global-control=all --innodb-monitor-enable=all --userstat=1' type='textarea' />
<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />
<@requirement.PARAM name='ROOT_PASSWORD' value='root' type='password' />
<@requirement.PARAM name='DEFAULT_DB_NAME' value='testdb' />

<@requirement.CONFORMS>
  <#assign PERCONA_VERSION='5.7.23_1' />
    
  <@swarm.NETWORK name='net-${namespace}' />

  <@swarm.STORAGE 'swarmstorage-percona-${namespace}' 'net-${namespace}' />

  <@swarm.SERVICE 'percona-${namespace}' 'imagenarium/percona-server:${PERCONA_VERSION}' PARAMS.DB_PARAMS>
    <@service.HOSTNAME 'percona-${namespace}' />
    <@service.NETWORK 'net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '3306' />
    <@service.CONS 'node.labels.percona' 'true' />
    <@service.VOLUME 'percona-volume-${namespace}' '/var/lib/mysql' />
    <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-percona-${namespace}' />
    <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@service.ENV 'MYSQL_ROOT_PASSWORD' PARAMS.ROOT_PASSWORD />
    <@service.ENV 'MYSQL_DATABASE' PARAMS.DEFAULT_DB_NAME />
    <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
    <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'pmm-${namespace}' 'imagenarium/pmm:latest'>
    <@service.NETWORK 'net-${namespace}' />
    <@service.PORT PARAMS.PMM_PUBLISHED_PORT '80' />
    <@service.CONS 'node.labels.percona' 'true' />
    <@service.VOLUME 'pmm-prometheus-${namespace}' '/opt/prometheus/data' />
    <@service.VOLUME 'pmm-consul-${namespace}' '/opt/consul-data' />
    <@service.VOLUME 'pmm-mysql-${namespace}' '/var/lib/mysql' />
    <@service.VOLUME 'pmm-grafana-${namespace}' '/var/lib/grafana' />
  </@swarm.SERVICE>
    
  <@docker.TCP_CHECKER 'percona-checker-${namespace}' 'percona-${namespace}:3306' 'net-${namespace}' />
  <@docker.HTTP_CHECKER 'pmm-checker-${namespace}' 'http://pmm-${namespace}:80/graph' 'net-${namespace}' />
</@requirement.CONFORMS>