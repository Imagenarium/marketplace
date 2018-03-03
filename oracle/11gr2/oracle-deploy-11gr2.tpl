<@requirement.CONS 'oracle' 'true' />

<@requirement.PARAM name='NEW_DB' value='false' type='boolean' scope='global' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' scope='global' />
<@requirement.PARAM name='DATA_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='PORT_MUTEX' value='11222' type='number' scope='global' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='network-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-oracle-${namespace}' 'network-${namespace}' />

  <@swarm.TASK 'oracle-${namespace}'>
    <@container.NETWORK 'network-${namespace}' />
    <@container.VOLUME 'oracle-volume-${namespace}' '/opt/oracle' PARAMS.VOLUME_DRIVER PARAMS.DATA_VOLUME_OPTS?trim />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-oracle-${namespace}' />
    <@container.ENV 'NEW_DB' PARAMS.NEW_DB />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'oracle-${namespace}' 'imagenarium/oracle:11gR2_10'>
    <@service.ENV 'PROXY_PORTS' '1521' />
    <@service.NETWORK 'network-${namespace}' />
    <@service.PORT_MUTEX PARAMS.PORT_MUTEX />
    <@service.CONS 'node.labels.oracle' 'true' />
  </@swarm.TASK_RUNNER>

  <@docker.CONTAINER 'oracle-checker-${namespace}' 'imagenarium/oracle_checker:latest'>
    <@container.NETWORK 'network-${namespace}' />
    <@container.ENV 'URL' 'system/oracle@//oracle-${namespace}:1521/orcl' />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
</@requirement.CONFORMS>