<@requirement.CONSTRAINT 'es-single' 'true' />

<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G -Des.enforce.bootstrap.checks=true' type='textarea' />
<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify Elasticsearch external port (for example 9200)' />

<#assign ES_VERSION='6.4.0' />
  
<@img.TASK 'es-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
  <@img.VOLUME '/usr/share/elasticsearch/data' />
  <@img.NETWORK 'es-net-${namespace}' />
  <@img.PORT PARAMS.PUBLISHED_PORT '9200' />
  <@img.CONSTRAINT 'es-single' 'true' />
  <@img.ULIMIT 'nofile=65536:65536' />
  <@img.ULIMIT 'nproc=4096:4096' />
  <@img.ULIMIT 'memlock=-1:-1' />
  <@img.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
  <@img.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
  <@img.ENV 'bootstrap.memory_lock' 'true' />
  <@img.ENV 'network.bind_host' '0.0.0.0' />
  <@img.ENV 'node.name' 'es-${namespace}' />
  <@img.CHECK_PATH ':9200/_cluster/health?wait_for_status=green&timeout=99999s' />
</@img.TASK>
