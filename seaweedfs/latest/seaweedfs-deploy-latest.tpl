<@swarm.NETWORK 'weed-network' />

<@node.DATACENTER ; dc, index, isLast>
  <#if !initialMaster??>
    <#assign initialMaster = 'weed-master-${dc}' />
    <#assign waitInitialMaster = true />
  </#if>

  <@swarm.SERVICE 'weed-master-${dc}' 'chrislusf/seaweedfs' 'replicated' 'master -defaultReplication=100 -ip=weed-master-${dc} -peers=${initialMaster}:9333'>
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

  <#-- Specify number of volume servers in each dc -->
  <#list 1..1 as x>
    <@swarm.SERVICE 'weed-volume-${dc}-${x}' 'chrislusf/seaweedfs' 'replicated' 'volume -dataCenter=${dc} -index=leveldb -ip=weed-volume-${dc}-${x} -mserver=weed-master-${dc}:9333'>
      <@service.DC dc />
      <@service.NETWORK 'weed-network' />
      <@service.VOLUME 'weed-volume-data-${x}' '/data' />
    </@swarm.SERVICE>
  </#list>
</@node.DATACENTER>
