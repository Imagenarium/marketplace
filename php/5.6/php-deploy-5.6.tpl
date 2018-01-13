<@requirement.NAMESPACE 'dev' />

<@requirement.CONFORMS>  
  <@swarm.TASK 'apache-php-${namespace}' 'imagenarium/php:5.6_1'>
    <@container.HOST_NETWORK />
    <@container.ENV 'php.memory_limit' '1024M' />
    <@container.ENV 'php.post_max_size' '500M' />
    <@container.ENV 'php.upload_max_filesize' '500M' />
    <@container.ENV 'php.max_execution_time' '600' />
    <@container.ENV 'php.max_input_time' '600' />
    <@container.ENV 'php.default_socket_timeout' '600' />
    <@container.ENV 'php.max_file_uploads' '100' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'apache-php-${namespace}' />
</@requirement.CONFORMS>