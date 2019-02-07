<@requirement.CONSTRAINT 'postgres' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />

<@requirement.PARAM name='POSTGRES_USER' value='postgres' />
<@requirement.PARAM name='POSTGRES_PASSWORD' value='postgres' />
<@requirement.PARAM name='POSTGRES_DB' value='postgres' />

<@requirement.PARAM name='PMM_ENABLE' value='false' type='boolean' />
<@requirement.PARAM name='PMM_USER' value='admin' scope='global' />
<@requirement.PARAM name='PMM_PASSWORD' value='admin' type='password' scope='global' />

<@swarm.SERVICE 'postgres-${namespace}' 'imagenarium/postgresql:11.1'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '5432' />
  <@service.VOLUME '/var/lib/postgresql/data' />
  <@service.CONSTRAINT 'postgres' 'true' />
  <@service.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
  <@service.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
  <@service.ENV 'POSTGRES_DB' PARAMS.POSTGRES_DB />
  <@service.ENV 'NETWORK_NAME' 'net-${namespace}' />
  <@service.ENV 'PMM' PARAMS.PMM_ENABLE />
  <@service.ENV 'PMM_USER' PARAMS.PMM_USER />
  <@service.ENV 'PMM_PASSWORD' PARAMS.PMM_PASSWORD />
  <@service.CHECK_PORT '5432' />
</@swarm.SERVICE>
