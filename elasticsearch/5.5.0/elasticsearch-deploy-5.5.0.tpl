<@requirement.HA />
<@requirement.CONS 'es' 'master' />
<@requirement.PARAM 'ES_JAVA_OPTS' '-Xms1G -Xmx1G' />

<@requirement.CONFORMS>
  <@bash.PROFILE>
    <@swarm.NETWORK 'monitoring' />

    <@swarm.SERVICE 'es-router' 'docker.elastic.co/elasticsearch/elasticsearch:5.5.0'>
      <@service.HOSTNAME 'es-router' />
      <@service.NETWORK 'monitoring' />
      <@service.DNSRR />
      <@service.ENV 'network.host' '0.0.0.0' />
      <@service.ENV 'ES_JAVA_OPTS' '-Xms512m -Xmx512m' />
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
  
    <@cloud.DATACENTER ; dc, index, isLast>
      <@swarm.SERVICE 'es-master-${dc}' 'docker.elastic.co/elasticsearch/elasticsearch:5.5.0'>
        <@service.HOSTNAME 'es-master-${dc}' />
        <@service.NETWORK 'monitoring' />
        <@service.VOLUME 'es-master-data-${randomUuid}' '/usr/share/elasticsearch/data' />
        <@service.DC dc />
        <@service.DNSRR />
        <@service.CONS 'node.labels.es' 'master' />
        <@service.ENV 'network.host' '0.0.0.0' />
        <@service.ENV 'ES_JAVA_OPTS' requirement.p.ES_JAVA_OPTS />
        <@service.ENV 'xpack.security.enabled' 'false' />
        <@service.ENV 'xpack.graph.enabled' 'false' />
        <@service.ENV 'xpack.ml.enabled' 'false' />
        <@service.ENV 'xpack.watcher.enabled' 'false' />
        <@service.ENV 'node.name' 'es-master-${dc}' />
        <@service.ENV 'discovery.zen.minimum_master_nodes' '2' />
        <@service.ENV 'discovery.zen.ping.unicast.hosts' 'es-router' />
      </@swarm.SERVICE>
    </@cloud.DATACENTER>

    <@cloud.DATACENTER ; dc, index, isLast>
      <@swarm.SERVICE 'es-worker-${dc}' 'docker.elastic.co/elasticsearch/elasticsearch:5.5.0' 'global'>
        <@service.NETWORK 'monitoring' />
        <@service.VOLUME 'es-worker-data-${randomUuid}' '/usr/share/elasticsearch/data' />
        <@service.DC dc />
        <@service.DNSRR />
        <@service.CONS 'node.labels.es' 'worker' />
        <@service.ENV 'network.host' '0.0.0.0' />
        <@service.ENV 'ES_JAVA_OPTS' requirement.p.ES_JAVA_OPTS />
        <@service.ENV 'xpack.security.enabled' 'false' />
        <@service.ENV 'xpack.graph.enabled' 'false' />
        <@service.ENV 'xpack.ml.enabled' 'false' />
        <@service.ENV 'xpack.watcher.enabled' 'false' />
        <@service.ENV 'node.master' 'false' />
        <@service.ENV 'discovery.zen.minimum_master_nodes' '2' />
        <@service.ENV 'discovery.zen.ping.unicast.hosts' 'es-router' />
      </@swarm.SERVICE>
    </@cloud.DATACENTER>
  </@bash.PROFILE>
</@requirement.CONFORMS>
