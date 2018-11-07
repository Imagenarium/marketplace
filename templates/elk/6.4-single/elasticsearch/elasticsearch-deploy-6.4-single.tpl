<@requirement.CONS 'es' 'true' />

<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G -Des.enforce.bootstrap.checks=true' type='textarea' />
<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify Elasticsearch external port (for example 9200)' />
<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />
<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <#assign ES_VERSION='6.4.0' />

  <@swarm.NETWORK name='es-net-${namespace}' />

  <@swarm.STORAGE 'swarmstorage-es-${namespace}' 'es-net-${namespace}' />
  
  <@swarm.TASK 'es-${namespace}'>
    <@container.NETWORK 'es-net-${namespace}' />
    <@container.VOLUME 'es-volume-${namespace}' '/usr/share/elasticsearch/data' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-es-${namespace}' />
    <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
    <@container.ENV 'bootstrap.memory_lock' 'true' />
    <@container.ENV 'network.bind_host' '0.0.0.0' />
    <@container.ENV 'index.number_of_replicas' '0' />
    <@container.ENV 'node.name' 'es-${namespace}' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'es-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
    <@service.CONS 'node.labels.es' 'true' />
    <@service.NETWORK 'es-net-${namespace}' />
    <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
    <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
  </@swarm.TASK_RUNNER>

  <@docker.HTTP_CHECKER 'es-checker-${namespace}' 'http://es-${namespace}-1:9200/_cluster/health?wait_for_status=green&timeout=99999s' 'es-net-${namespace}' />
</@requirement.CONFORMS>
