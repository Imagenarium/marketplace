<@bash.PROFILE>
  <@swarm.NETWORK 'monitoring' />
  
  <@node.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'es-master-${dc}' 'docker.elastic.co/elasticsearch/elasticsearch:5.5.0'>
      <@service.HOSTNAME 'es-master-${dc}' />
      <@service.NETWORK 'monitoring' />
      <@service.VOLUME 'esdata' '/usr/share/elasticsearch/data' />
      <@service.CONS 'dc' dc />

      <@service.ENV 'network.host' '0.0.0.0' />
      <@service.ENV 'ES_JAVA_OPTS' '-Xms1G -Xmx1G' />
      <@service.ENV 'xpack.security.enabled' 'false' />
      <@service.ENV 'xpack.graph.enabled' 'false' />
      <@service.ENV 'xpack.ml.enabled' 'false' />
      <@service.ENV 'xpack.watcher.enabled' 'false' />
      <@service.ENV 'node.name' 'es-master-${dc}' />
      <@service.ENV 'discovery.zen.minimum_master_nodes' '2' />
      <@service.ENV 'discovery.zen.ping.unicast.hosts' 'es-router' />
    </@swarm.SERVICE>
  </@node.DATACENTER>

  <@swarm.SERVICE 'es-router' 'docker.elastic.co/elasticsearch/elasticsearch:5.5.0'>
    <@service.HOSTNAME 'es-router' />
    <@service.NETWORK 'monitoring' />

    <@service.ENV 'network.host' '0.0.0.0' />
    <@service.ENV 'ES_JAVA_OPTS' '-Xms1G -Xmx1G' />
    <@service.ENV 'xpack.security.enabled' 'false' />
    <@service.ENV 'xpack.graph.enabled' 'false' />
    <@service.ENV 'xpack.ml.enabled' 'false' />
    <@service.ENV 'xpack.watcher.enabled' 'false' />
    <@service.ENV 'node.name' 'es-router' />
    <@service.ENV 'node.master' 'false' />
    <@service.ENV 'node.data' 'false' />
    <@service.ENV 'node.ingest' 'false' />
    <@service.ENV 'discovery.zen.minimum_master_nodes' '2' />
  </@swarm.SERVICE>
</@bash.PROFILE>