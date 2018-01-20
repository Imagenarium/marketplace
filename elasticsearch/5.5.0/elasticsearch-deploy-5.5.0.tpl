<@requirement.HA />
<@requirement.CONS_HA 'es' 'master' />
<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <#assign NETMASK=randomNetmask24 />
  <@swarm.NETWORK 'es-net-${namespace}' '${NETMASK}.0/24' />

  <@swarm.TASK 'es-router-${namespace}' 'imagenarium/elasticsearch:5.5.0_1'>
    <@container.NETWORK 'es-net-${namespace}' />
    <@container.ULIMIT 'nofile=65536:65536' />
    <@container.ULIMIT 'memlock=-1:-1' />
    <@container.ENV 'es.enforce.bootstrap.checks' 'true' />
    <@container.ENV 'bootstrap.memory_lock' 'true' />
    <@container.ENV 'network.bind_host' '0.0.0.0' />
    <@container.ENV 'NETMASK' NETMASK />
    <@container.ENV 'ES_JAVA_OPTS' '-Xms512m -Xmx512m' />
    <@container.ENV 'xpack.security.enabled' 'false' />
    <@container.ENV 'xpack.graph.enabled' 'false' />
    <@container.ENV 'xpack.ml.enabled' 'false' />
    <@container.ENV 'xpack.watcher.enabled' 'false' />
    <@container.ENV 'node.name' 'es-router-${namespace}' />
    <@container.ENV 'node.master' 'false' />
    <@container.ENV 'node.data' 'false' />
    <@container.ENV 'node.ingest' 'false' />
    <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'es-router-${namespace}' />
  
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.TASK 'es-master-${dc}-${namespace}' 'imagenarium/elasticsearch:5.5.0_1'>
      <@container.NETWORK 'es-net-${namespace}' />
      <@container.VOLUME 'es-master-data-${namespace}' '/usr/share/elasticsearch/data' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.ENV 'es.enforce.bootstrap.checks' 'true' />
      <@container.ENV 'bootstrap.memory_lock' 'true' />
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'network.bind_host' '0.0.0.0' />
      <@container.ENV 'NETMASK' NETMASK />
      <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
      <@container.ENV 'xpack.security.enabled' 'false' />
      <@container.ENV 'xpack.graph.enabled' 'false' />
      <@container.ENV 'xpack.ml.enabled' 'false' />
      <@container.ENV 'xpack.watcher.enabled' 'false' />
      <@container.ENV 'node.name' 'es-master-${dc}-${namespace}' />
      <@container.ENV 'cluster.routing.allocation.awareness.attributes' 'dc' />
      <@container.ENV 'cluster.routing.allocation.awareness.force.zone.values' swarmService.getDistinctNodeLabelValues('dc')?join(",") />
      <@container.ENV 'node.attr.dc' dc />
      <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
      <@container.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}.1' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'es-master-${dc}-${namespace}'>
      <@service.DC dc />
      <@service.CONS 'node.labels.es' 'master' />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.TASK 'es-worker-${dc}-${namespace}' 'imagenarium/elasticsearch:5.5.0_1' 'global'>
      <@container.NETWORK 'es-net-${namespace}' />
      <@container.VOLUME 'es-worker-data-${namespace}' '/usr/share/elasticsearch/data' />
      <@container.ULIMIT 'nofile=65536:65536' />
      <@container.ULIMIT 'memlock=-1:-1' />
      <@container.ENV 'es.enforce.bootstrap.checks' 'true' />
      <@container.ENV 'bootstrap.memory_lock' 'true' />
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'network.bind_host' '0.0.0.0' />
      <@container.ENV 'NETMASK' NETMASK />
      <@container.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
      <@container.ENV 'xpack.security.enabled' 'false' />
      <@container.ENV 'xpack.graph.enabled' 'false' />
      <@container.ENV 'xpack.ml.enabled' 'false' />
      <@container.ENV 'xpack.watcher.enabled' 'false' />
      <@container.ENV 'node.master' 'false' />
      <@container.ENV 'cluster.routing.allocation.awareness.attributes' 'dc' />
      <@container.ENV 'cluster.routing.allocation.awareness.force.zone.values' swarmService.getDistinctNodeLabelValues('dc')?join(",") />
      <@container.ENV 'node.attr.dc' dc />
      <@container.ENV 'discovery.zen.minimum_master_nodes' '2' />
      <@container.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}.1' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'es-worker-${dc}-${namespace}'>
      <@service.DC dc />
      <@service.CONS 'node.labels.es' 'worker' />
    </@swarm.TASK_RUNNER>
  </@cloud.DATACENTER>

  <@docker.HTTP_CHECK 'http://es-router-${namespace}.1:9200/_cluster/health?wait_for_status=green&timeout=99999s' 'es-net-${namespace}' />
</@requirement.CONFORMS>
