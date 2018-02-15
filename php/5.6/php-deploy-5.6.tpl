<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' scope='global' />
<@requirement.PARAM name='PUBLISHED_PORT' value='8080' type='port' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='sylex-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.TASK 'apache-php-${namespace}'>
    <@container.NETWORK 'sylex-net-${namespace}' />
    <@container.ENV 'FILESTORAGE_PATH' '/mnt/filestorage' />
    <@container.ENV 'TEMP_PATH' '/mnt/temp' />
    <@container.ENV 'FILESTORAGE_SERVER' 'nfs-filestorage-${namespace}' />
    <@container.ENV 'TEMP_SERVER' 'nfs-temp-${namespace}' />
    <@container.ENV 'php.memory_limit' '1024M' />
    <@container.ENV 'php.post_max_size' '500M' />
    <@container.ENV 'php.upload_max_filesize' '500M' />
    <@container.ENV 'php.max_execution_time' '600' />
    <@container.ENV 'php.max_input_time' '600' />
    <@container.ENV 'php.default_socket_timeout' '600' />
    <@container.ENV 'php.max_file_uploads' '100' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'apache-php-${namespace}' 'imagenarium/php:5.6_6'>
    <@service.NETWORK 'sylex-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'PROXY_PORTS' '8080' />
    <@service.ENV 'DST_PORTS' '80' />
  </@swarm.TASK_RUNNER>

  <@docker.HTTP_CHECK 'http://apache-php-${namespace}:8080' 'sylex-net-${namespace}' />
</@requirement.CONFORMS>