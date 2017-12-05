<@requirement.HA />
<@requirement.CONS_HA 'es' 'master' />
<@requirement.PARAM name='ES_JAVA_OPTS' value='-Xms1G -Xmx1G' />
<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'es-net-${namespace}' />

  <@swarm.SERVICE 'es-router-${namespace}' 'docker.elastic.co/elasticsearch/elasticsearch:5.5.0'>
    <@service.HOSTNAME 'es-router-${namespace}' />
    <@service.NETWORK 'es-net-${namespace}' />
    <@service.DNSRR />
    <@service.ENV 'network.host' '0.0.0.0' />
    <@service.ENV 'ES_JAVA_OPTS' '-Xms512m -Xmx512m' />
    <@service.ENV 'xpack.security.enabled' 'false' />
    <@service.ENV 'xpack.graph.enabled' 'false' />
    <@service.ENV 'xpack.ml.enabled' 'false' />
    <@service.ENV 'xpack.watcher.enabled' 'false' />
    <@service.ENV 'node.name' 'es-router-${namespace}' />
    <@service.ENV 'node.master' 'false' />
    <@service.ENV 'node.data' 'false' />
    <@service.ENV 'node.ingest' 'false' />
    <@service.ENV 'discovery.zen.minimum_master_nodes' '2' />
  </@swarm.SERVICE>
  
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'es-master-${dc}-${namespace}' 'docker.elastic.co/elasticsearch/elasticsearch:5.5.0'>
      <@service.HOSTNAME 'es-master-${dc}-${namespace}' />
      <@service.NETWORK 'es-net-${namespace}' />
      <@service.VOLUME 'es-master-data-${namespace}' '/usr/share/elasticsearch/data' />
      <@service.DC dc />
      <@service.DNSRR />
      <@service.CONS 'node.labels.es' 'master' />
      <@service.ENV 'network.host' '0.0.0.0' />
      <@service.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
      <@service.ENV 'xpack.security.enabled' 'false' />
      <@service.ENV 'xpack.graph.enabled' 'false' />
      <@service.ENV 'xpack.ml.enabled' 'false' />
      <@service.ENV 'xpack.watcher.enabled' 'false' />
      <@service.ENV 'node.name' 'es-master-${dc}-${namespace}' />
      <@service.ENV 'cluster.routing.allocation.awareness.attributes' 'dc' />
      <@service.ENV 'node.attr.dc' dc />
      <@service.ENV 'discovery.zen.minimum_master_nodes' '2' />
      <@service.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'es-worker-${dc}-${namespace}' 'docker.elastic.co/elasticsearch/elasticsearch:5.5.0' 'global'>
      <@service.NETWORK 'es-net-${namespace}' />
      <@service.VOLUME 'es-worker-data-${namespace}' '/usr/share/elasticsearch/data' />
      <@service.DC dc />
      <@service.DNSRR />
      <@service.CONS 'node.labels.es' 'worker' />
      <@service.ENV 'network.host' '0.0.0.0' />
      <@service.ENV 'ES_JAVA_OPTS' PARAMS.ES_JAVA_OPTS />
      <@service.ENV 'xpack.security.enabled' 'false' />
      <@service.ENV 'xpack.graph.enabled' 'false' />
      <@service.ENV 'xpack.ml.enabled' 'false' />
      <@service.ENV 'xpack.watcher.enabled' 'false' />
      <@service.ENV 'node.master' 'false' />
      <@service.ENV 'cluster.routing.allocation.awareness.attributes' 'dc' />
      <@service.ENV 'node.attr.dc' dc />
      <@service.ENV 'discovery.zen.minimum_master_nodes' '2' />
      <@service.ENV 'discovery.zen.ping.unicast.hosts' 'es-router-${namespace}' />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>

  <@docker.HTTP_CHECK 'http://es-router-${namespace}:9200/_cluster/health?wait_for_status=green&timeout=99999s' 'es-net-${namespace}' />
</@requirement.CONFORMS>
