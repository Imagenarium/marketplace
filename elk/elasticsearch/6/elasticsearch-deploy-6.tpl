<@requirement.CONS 'es' 'master1' />
<@requirement.CONS 'es' 'master2' />
<@requirement.CONS 'es' 'master3' />

<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G -Des.enforce.bootstrap.checks=true' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <#assign ES_VERSION='6.2.2' />
  <@swarm.NETWORK name='es-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-es-${namespace}' 'es-net-${namespace}' />

  <@swarm.TASK 'es-router-${namespace}'>
    <@container.NETWORK 'es-net-${namespace}' />
    <@container.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-es-${namespace}' />
    <@container.ENV 'bootstrap.memory_lock' 'true' />
    <@container.ENV 'network.bind_host' '0.0.0.0' />
    <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
    <@container.ENV 'node.name' 'es-router-${namespace}' />
    <@container.ENV 'node.master' 'false' />
    <@container.ENV 'node.data' 'false' />
    <@container.ENV 'search.remote.connect' 'false' />
    <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'es-router-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
    <@service.ENV 'PROXY_PORTS' '9200' />
    <@service.NETWORK 'es-net-${namespace}' />
  </@swarm.TASK_RUNNER>
  
  <#list "1,2,3"?split(",") as index>
    <#if PARAMS.DELETE_DATA == 'true' && PARAMS.VOLUME_DRIVER != 'local'>
      <@swarm.VOLUME_RM 'es-master-volume-${index}-${namespace}' />
    </#if>

    <@swarm.TASK 'es-master-${index}-${namespace}'>
      <@container.NETWORK 'es-net-${namespace}' />
      <@container.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
      <@container.VOLUME 'es-master-volume-${index}-${namespace}' '/usr/share/elasticsearch/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'nproc=4096:4096' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.ENV 'VOLUME_DRIVER' PARAMS.VOLUME_DRIVER />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-es-${namespace}' />
      <@container.ENV 'bootstrap.memory_lock' 'true' />
      <@container.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
      <@container.ENV 'network.bind_host' '0.0.0.0' />
      <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
      <@container.ENV 'node.name' 'es-master-${index}-${namespace}' />
      <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
      <@container.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}.1' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'es-master-${index}-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
      <@service.CONS 'node.labels.es' 'master${index}' />
      <@service.NETWORK 'es-net-${namespace}' />
      <@service.ENV 'PROXY_PORTS' '9200' />
    </@swarm.TASK_RUNNER>
  </#list>

  <@docker.HTTP_CHECKER 'es-checker-${namespace}' 'http://es-router-${namespace}:9200/_cluster/health?wait_for_status=green&timeout=99999s' 'es-net-${namespace}' />
</@requirement.CONFORMS>
