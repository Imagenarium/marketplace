<@swarm.NETWORK 'weed-network' />

<@node.DATACENTER ; dc, index, isLast>
  <#if !initialMaster??>
    <#assign initialMaster = 'weed-master-${dc}' />
    <#assign waitInitialMaster = true />
  </#if>

  <@swarm.SERVICE 'weed-master-${dc}' 'chrislusf/seaweedfs' 'replicated' 'master -defaultReplication=100 -peers=http://${initialMaster}:9333'>
    <@service.DC dc />
    <@service.NETWORK 'weed-network' />
    <@service.VOLUME 'weed-master-data' '/data' />
  </@swarm.SERVICE>

  <#if waitInitialMaster>
    <@docker.CONTAINER 'weed-master-checker' 'imagenarium/seaweedfs-master-checker:0.1'>
      <@container.NETWORK 'weed-network' />
      <@container.EPHEMERAL />
      <@container.ENV 'MASTER_HOST' initialMaster />
    </@docker.CONTAINER>

    <#assign waitInitialMaster = false />
  </#if>

  <@swarm.SERVICE 'weed-volume-${dc}' 'chrislusf/seaweedfs' 'replicated' 'volume -dataCenter=${dc} -max=5 -index=leveldb -mserver=weed-master-${dc}:9333'>
    <@service.DC dc />
    <@service.NETWORK 'weed-network' />
    <@service.VOLUME 'weed-volume-data' '/data' />
  </@swarm.SERVICE>
</@node.DATACENTER>

