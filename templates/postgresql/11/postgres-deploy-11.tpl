<@requirement.CONSTRAINT 'postgres' 'true' />

<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify postgres external port (for example 5432)' />

<@requirement.PARAM name='POSTGRES_USER' value='postgres' />
<@requirement.PARAM name='POSTGRES_PASSWORD' value='postgres' />
<@requirement.PARAM name='POSTGRES_DB' value='postgres' />

<@requirement.PARAM name='PMM_ENABLE' value='false' type='boolean' />
<@requirement.PARAM name='PMM_USER' value='admin' scope='global' />
<@requirement.PARAM name='PMM_PASSWORD' value='admin' type='password' scope='global' />

<@requirement.PARAM name='CMD' value='-c max_connections=1000 -c shared_buffers=1GB' type='textarea' />

<@img.TASK 'postgres-${namespace}' 'imagenarium/postgresql:11.2' PARAMS.CMD>
  <@img.NETWORK 'net-${namespace}' />
  <@img.PORT PARAMS.PUBLISHED_PORT '5432' />
  <@img.VOLUME '/var/lib/postgresql/data' />
  <@img.BIND '/sys/kernel/mm/transparent_hugepage' '/tph' />
  <@img.CONSTRAINT 'postgres' 'true' />
  <@img.ENV 'POSTGRES_USER' PARAMS.POSTGRES_USER />
  <@img.ENV 'POSTGRES_PASSWORD' PARAMS.POSTGRES_PASSWORD />
  <@img.ENV 'POSTGRES_DB' PARAMS.POSTGRES_DB />
  <@img.ENV 'NETWORK_NAME' 'net-${namespace}' />
  <@img.ENV 'PMM' PARAMS.PMM_ENABLE />
  <@img.ENV 'PMM_USER' PARAMS.PMM_USER />
  <@img.ENV 'PMM_PASSWORD' PARAMS.PMM_PASSWORD />
  <@img.CHECK_PORT '5432' />
</@swarm.SERVICE>
