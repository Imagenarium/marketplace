<@swarm.NETWORK 'weed-network' />

<@node.DATACENTER ; dc, index, isLast>
  <#assign peers = [] />

  <@node.DATACENTER ; _dc, _index, _isLast>
    <#if dc != _dc>
      <#assign peers += ["weed-master-${_dc}:9333"] />
    </#if>
  </@node.DATACENTER>

  <@swarm.SERVICE 'weed-master-${dc}' 'chrislusf/seaweedfs' 'replicated' 'master -defaultReplication=100 -peers=${peers?join(",")}'>
    <@service.DC dc />
    <@service.NETWORK 'weed-network' />
    <@service.VOLUME 'weed-master-data' '/data' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'weed-volume-${dc}' 'chrislusf/seaweedfs' 'replicated' 'volume -dataCenter=${dc} -max=5 -index=leveldb -mserver=weed-master-${dc}:9333'>
    <@service.DC dc />
    <@service.NETWORK 'weed-network' />
    <@service.VOLUME 'weed-volume-data' '/data' />
  </@swarm.SERVICE>
</@node.DATACENTER>

