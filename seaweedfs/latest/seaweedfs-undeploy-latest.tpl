<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'weed-master-${dc}' />
  <#list 1..1 as x>
    <@swarm.SERVICE_RM 'weed-volume-${dc}-${x}' />
  </#list>
</@node.DATACENTER>

<@swarm.NETWORK_RM 'weed-network' />