<@requirement.CONSTRAINT 'es' 'master1' />
<@requirement.CONSTRAINT 'es' 'master2' />
<@requirement.CONSTRAINT 'es' 'master3' />

<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G -Des.enforce.bootstrap.checks=true' type='textarea' />
<@requirement.PARAM name='PUBLISHED_PORT' type='port' required='false' description='Specify Elasticsearch external port (for example 9200)' />

<#assign ES_VERSION='6.4.0' />

<@swarm.TASK 'es-router-${namespace}'>
  <@container.NETWORK 'es-net-${namespace}' />
  <@container.ULIMIT 'nofile=65536:65536' />
  <@container.ULIMIT 'nproc=4096:4096' />
  <@container.ULIMIT 'memlock=-1:-1' />
  <@container.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
  <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
  <@container.ENV 'bootstrap.memory_lock' 'true' />
  <@container.ENV 'network.bind_host' '0.0.0.0' />
  <@container.ENV 'node.name' 'es-router-${namespace}' />
  <@container.ENV 'node.master' 'false' />
  <@container.ENV 'node.data' 'false' />
  <@container.ENV 'search.remote.connect' 'false' />
  <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
</@swarm.TASK>

<@swarm.TASK_RUNNER 'es-router-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
  <@service.PORT PARAMS.PUBLISHED_PORT '9200' />
  <@service.ENV 'PROXY_PORTS' '9200' />
</@swarm.TASK_RUNNER>
  
<#list "1,2,3"?split(",") as index>
  <@swarm.TASK 'es-master-${index}-${namespace}'>
    <@container.NETWORK 'es-net-${namespace}' />
    <@container.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
    <@container.VOLUME '/usr/share/elasticsearch/data' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'nproc=4096:4096' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
    <@container.ENV 'bootstrap.memory_lock' 'true' />
    <@container.ENV 'network.bind_host' '0.0.0.0' />
    <@container.ENV 'node.name' 'es-master-${index}-${namespace}' />
    <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
    <@container.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}-1' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'es-master-${index}-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
    <@service.CONSTRAINT 'es' 'master${index}' />
  </@swarm.TASK_RUNNER>
</#list>

<@docker.HTTP_CHECKER 'es-checker-${namespace}' 'http://es-router-${namespace}-1:9200/_cluster/health?wait_for_status=green&timeout=99999s' 'es-net-${namespace}' />
