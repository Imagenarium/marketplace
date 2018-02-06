<@requirement.NAMESPACE 'dev' />
<@requirement.PARAM name='PUBLISHED_PORT' value='8080' type='number' />

<@requirement.CONFORMS>  
  <@swarm.NETWORK 'frontend-net-${namespace}' />

  <@swarm.SERVICE 'apache-php-${namespace}' 'imagenarium/php:5.6_4'>
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'php.memory_limit' '1024M' />
    <@service.ENV 'php.post_max_size' '500M' />
    <@service.ENV 'php.upload_max_filesize' '500M' />
    <@service.ENV 'php.max_execution_time' '600' />
    <@service.ENV 'php.max_input_time' '600' />
    <@service.ENV 'php.default_socket_timeout' '600' />
    <@service.ENV 'php.max_file_uploads' '100' />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECK 'http://apache-php-${namespace}:8080' 'frontend-net-${namespace}' />
</@requirement.CONFORMS>