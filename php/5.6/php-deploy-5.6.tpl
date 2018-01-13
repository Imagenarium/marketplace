<@requirement.NAMESPACE 'dev' />

<@requirement.CONFORMS>  
  <@swarm.TASK 'apache-php-${namespace}' 'imagenarium/php:5.6_4'>
    <@container.HOST_NETWORK />
    <@container.ENV 'CHECK_PORT' '80' />
    <@container.ENV 'php.memory_limit' '1024M' />
    <@container.ENV 'php.post_max_size' '500M' />
    <@container.ENV 'php.upload_max_filesize' '500M' />
    <@container.ENV 'php.max_execution_time' '600' />
    <@container.ENV 'php.max_input_time' '600' />
    <@container.ENV 'php.default_socket_timeout' '600' />
    <@container.ENV 'php.max_file_uploads' '100' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'apache-php-${namespace}'>
    <@service.PORT '8080' '8080' />
    <@service.ENV 'SERVICE_PORTS' '8080' />
    <@service.ENV 'DST_PORT' '80' />
  </@swarm>
</@requirement.CONFORMS>