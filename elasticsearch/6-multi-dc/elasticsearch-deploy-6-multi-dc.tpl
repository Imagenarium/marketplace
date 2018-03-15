<@requirement.HA />
<@requirement.CONS_HA 'es' 'master' />

<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G -Des.enforce.bootstrap.checks=true' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' type='volume_driver' />
<@requirement.PARAM name='VOLUME_SIZE_GB' value='1' type='number' />

<@requirement.CONFORMS>
  <#assign ES_VERSION='6.2.2_1' />
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
    <@container.ENV 'ES_JAVA_OPTS' '-Xms512m -Xmx512m -Des.enforce.bootstrap.checks=true' />
    <@container.ENV 'node.name' 'es-router-${namespace}' />
    <@container.ENV 'node.master' 'false' />
    <@container.ENV 'node.data' 'false' />
    <@container.ENV 'node.ingest' 'false' />
    <@container.ENV 'search.remote.connect' 'false' />
    <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'es-router-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}' />
  
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.TASK 'es-master-${index}-${namespace}'>
      <@container.NETWORK 'es-net-${namespace}' />
      <@container.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
      <@container.VOLUME 'es-master-data-${index}-${namespace}' '/usr/share/elasticsearch/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'nproc=4096:4096' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-es-${namespace}' />
      <@container.ENV 'bootstrap.memory_lock' 'true' />
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'network.bind_host' '0.0.0.0' />
      <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
      <@container.ENV 'node.name' 'es-master-${index}-${namespace}' />
      <@container.ENV 'cluster.routing.allocation.awareness.attributes' 'dc' />
      <@container.ENV 'cluster.routing.allocation.awareness.force.zone.values' swarmService.getDistinctNodeLabelValues('dc')?join(",") />
      <@container.ENV 'node.attr.dc' dc />
      <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
      <@container.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}.1' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'es-master-${index}-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
      <@service.DC dc />
      <@service.CONS 'node.labels.es' 'master' />
      <@service.ENV 'PROXY_PORTS' '9200' />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.TASK 'es-worker-${index}-${namespace}'>
      <@container.NETWORK 'es-net-${namespace}' />
      <@container.ENV 'NETWORK_NAME' 'es-net-${namespace}' />
      <@container.VOLUME 'es-worker-data-${index}-${namespace}' '/usr/share/elasticsearch/data' PARAMS.VOLUME_DRIVER 'volume-opt=size=${PARAMS.VOLUME_SIZE_GB}gb' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'nproc=4096:4096' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-es-${namespace}' />
      <@container.ENV 'bootstrap.memory_lock' 'true' />
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'network.bind_host' '0.0.0.0' />
      <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
      <@container.ENV 'node.master' 'false' />
      <@container.ENV 'cluster.routing.allocation.awareness.attributes' 'dc' />
      <@container.ENV 'cluster.routing.allocation.awareness.force.zone.values' swarmService.getDistinctNodeLabelValues('dc')?join(",") />
      <@container.ENV 'node.attr.dc' dc />
      <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
      <@container.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}.1' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'es-worker-${index}-${namespace}' 'imagenarium/elasticsearch:${ES_VERSION}'>
      <@service.DC dc />
      <@service.PORT_MUTEX '13131' />
      <@service.REPLICAS '0' />
      <@service.CONS 'node.labels.es' 'worker' />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>

  <@docker.HTTP_CHECKER 'es-checker-${namespace}' 'http://es-router-${namespace}.1:9200/_cluster/health?wait_for_status=green&timeout=99999s' 'es-net-${namespace}' />
</@requirement.CONFORMS>
