<@node.DATACENTER ; dc, index, isLast>
  <#list 1..2 as i>
    <@swarm.SERVICE_RM 'minio-${dc}${i}' />
  </#list>
</@node.DATACENTER>

<@swarm.NETWORK_RM 'minionet' />
