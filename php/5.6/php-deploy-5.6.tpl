<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='PUBLISHED_PORT' value='8080' type='port' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='frontend-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.TASK 'apache-php-${namespace}'>
    <@container.ENV 'FILESTORAGE_PATH' '/mnt/filestorage' />
    <@container.ENV 'TEMP_PATH' '/mnt/temp' />
    <@container.ENV 'FILESTORAGE_SERVER' 'nfs-filestorage-${namespace}.1' />
    <@container.ENV 'TEMP_SERVER' 'nfs-temp-${namespace}.1' />
    <@container.ENV 'php.memory_limit' '1024M' />
    <@container.ENV 'php.post_max_size' '500M' />
    <@container.ENV 'php.upload_max_filesize' '500M' />
    <@container.ENV 'php.max_execution_time' '600' />
    <@container.ENV 'php.max_input_time' '600' />
    <@container.ENV 'php.default_socket_timeout' '600' />
    <@container.ENV 'php.max_file_uploads' '100' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'apache-php-${namespace}' 'imagenarium/php:5.6_5'>
    <@service.NETWORK 'frontend-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'PROXY_PORTS' '8080' />
    <@service.ENV 'DST_PORTS' '80' />
  </@swarm.TASK_RUNNER>

  <@docker.HTTP_CHECK 'http://apache-php-${namespace}:8080' 'frontend-net-${namespace}' />
</@requirement.CONFORMS>