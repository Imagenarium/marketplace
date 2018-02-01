<@requirement.PARAM name='PUBLISHED_PORT' value='8080' type='number' />
<@requirement.PARAM name='BASE_URL' value='http://localhost:8080/sd' />
<@requirement.PARAM name='NEW_DB' value='false' type='boolean' />
<@requirement.PARAM name='ORACLE_SID' value='orcl' />
<@requirement.PARAM name='ORACLE_USER' value='system' />
<@requirement.PARAM name='ORACLE_PASSWORD' value='oracle' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' values='vmware,do,local' type='select' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'network-${namespace}' />

  <@swarm.SERVICE 'swarmstorage-servicedesk-${namespace}' 'imagenarium/swarmstorage:0.5.0'>
    <@service.NETWORK 'network-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'servicedesk-${namespace}' 'imagenarium/servicedesk:0.3'>
    <@service.PORT_MUTEX '11222' />
    <@service.NETWORK 'network-${namespace}' />
    <@service.DOCKER_SOCKET />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.VOLUME 'servicedesk-volume-${namespace}' '/opt/nausd40/data' PARAMS.VOLUME_DRIVER />
    <@service.ENV 'NEW_DB' PARAMS.NEW_DB />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-servicedesk-${namespace}' />
    <@service.ENV 'BASE_URL' PARAMS.BASE_URL />
    <@service.ENV 'ORACLE_HOSTNAME' 'oracle-${namespace}' />
    <@service.ENV 'ORACLE_SID' PARAMS.ORACLE_SID />
    <@service.ENV 'ORACLE_USER' PARAMS.ORACLE_USER />
    <@service.ENV 'ORACLE_PASSWORD' PARAMS.ORACLE_PASSWORD />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECK 'http://servicedesk-${namespace}:8080/sd/services/rest/check-status' 'network-${namespace}' />
</@requirement.CONFORMS>
