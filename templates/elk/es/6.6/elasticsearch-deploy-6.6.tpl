<@requirement.CONSTRAINT 'es-router' 'true' />
<@requirement.CONSTRAINT 'es-master' '1' />
<@requirement.CONSTRAINT 'es-master' '2' />
<@requirement.CONSTRAINT 'es-master' '3' />

<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G -Des.enforce.bootstrap.checks=true' type='textarea' />
<@requirement.PARAM name='ES_PUBLISHED_PORT' type='port' required='false' description='Specify Elasticsearch external port (for example 9200)' />

<#assign ES_VERSION='6.6.0' />

<@img.TASK 'es-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
  <@img.ULIMIT 'nofile=65536:65536' />
  <@img.ULIMIT 'nproc=4096:4096' />
  <@img.ULIMIT 'memlock=-1:-1' />
  <@img.NETWORK 'net-${namespace}' />
  <@img.DNSRR />
  <@img.CONSTRAINT 'es-router' 'true' />
  <@img.PORT PARAMS.ES_PUBLISHED_PORT '9200' 'host' />
  <@img.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
  <@img.ENV 'bootstrap.memory_lock' 'true' />
  <@img.ENV 'network.bind_host' '0.0.0.0' />
  <@img.ENV 'node.name' 'es-${namespace}' />
  <@img.ENV 'node.master' 'false' />
  <@img.ENV 'node.data' 'false' />
  <@img.ENV 'node.ingest' 'false' />
  <@img.ENV 'search.remote.connect' 'false' />
  <@img.ENV 'discovery.zen.minimum_master_nodes' '2' />
  <@img.CHECK_PORT '9200' />
</@img.TASK>
  
<#list "1,2,3"?split(",") as index>
  <@img.TASK 'es-master-${index}-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
    <@img.VOLUME '/usr/share/elasticsearch/data' />
    <@img.NETWORK 'net-${namespace}' />
    <@img.DNSRR />
    <@img.CONSTRAINT 'es-master' '${index}' />
    <@img.ULIMIT 'nofile=65536:65536' />
    <@img.ULIMIT 'nproc=4096:4096' />
    <@img.ULIMIT 'memlock=-1:-1' />
    <@img.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
    <@img.ENV 'bootstrap.memory_lock' 'true' />
    <@img.ENV 'network.bind_host' '0.0.0.0' />
    <@img.ENV 'node.name' 'es-master-${index}-${namespace}' />
    <@img.ENV 'discovery.zen.minimum_master_nodes' '2' />
    <@img.ENV 'discovery.zen.ping.unicast.hosts' 'es-${namespace}' />
    <@img.CHECK_PORT '9200' />
  </@img.TASK>
</#list>

<@docker.HTTP_CHECKER 'es-checker-${namespace}' 'http://es-${namespace}:9200/_cluster/health?wait_for_status=green&timeout=99999s' 'net-${namespace}' />
