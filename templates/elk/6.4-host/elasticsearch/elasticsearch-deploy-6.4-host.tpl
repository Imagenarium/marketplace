<@requirement.CONS 'es-router' 'true' />
<@requirement.CONS 'es' 'master1' />
<@requirement.CONS 'es' 'master2' />
<@requirement.CONS 'es' 'master3' />

<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G -Des.enforce.bootstrap.checks=true' type='textarea' />
<@requirement.PARAM name='DELETE_DATA' value='true' type='boolean' scope='global' />
<@requirement.PARAM name='ADMIN_MODE' value='false' type='boolean' />
<@requirement.PARAM name='RUN_APP'    value='true'  type='boolean' />

<@requirement.CONFORMS>
  <#assign ES_VERSION='6.4.0' />

  <@swarm.TASK 'es-router-${namespace}'>
    <@container.HOST_NETWORK />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage' />
    <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
    <@container.ENV 'bootstrap.memory_lock' 'true' />
    <@container.ENV 'network.bind_host' '0.0.0.0' />
    <#--<@container.ENV 'network.publish_host' '' />-->
    <@container.ENV 'node.name' 'es-router-${namespace}' />
    <@container.ENV 'node.master' 'false' />
    <@container.ENV 'node.data' 'false' />
    <@container.ENV 'search.remote.connect' 'false' />
    <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'es-router-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
    <@service.CONS 'node.labels.es-router' 'true' />
    <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
    <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
  </@swarm.TASK_RUNNER>
  
  <#list "1,2,3"?split(",") as index>
    <@swarm.TASK 'es-master-${index}-${namespace}'>
      <@container.HOST_NETWORK />
      <@container.VOLUME 'es-master-volume-${index}-${namespace}' '/usr/share/elasticsearch/data' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'nproc=4096:4096' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage' />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
      <@container.ENV 'bootstrap.memory_lock' 'true' />
      <@container.ENV 'network.bind_host' '0.0.0.0' />
      <#--<@container.ENV 'network.publish_host' '' />-->
      <@container.ENV 'node.name' 'es-master-${index}-${namespace}' />
      <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
      <@container.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}-1' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'es-master-${index}-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
      <@service.CONS 'node.labels.es' 'master${index}' />
      <@service.ENV 'IMAGENARIUM_ADMIN_MODE' PARAMS.ADMIN_MODE />
      <@service.ENV 'IMAGENARIUM_RUN_APP' PARAMS.RUN_APP />
    </@swarm.TASK_RUNNER>
  </#list>

  <@docker.HTTP_CHECKER 'es-checker-${namespace}' 'http://es-router-${namespace}-1:9200/_cluster/health?wait_for_status=green&timeout=99999s' />
</@requirement.CONFORMS>
