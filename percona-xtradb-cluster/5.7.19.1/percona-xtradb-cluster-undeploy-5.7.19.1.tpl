<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'percona-init-${uniqueId}' />

  <#list "dc3,dc2,dc1"?split(",") as orderedDc>  
    <@cloud.DATACENTER ; dc, index, isLast>
      <#if dc == orderedDc>
        <@swarm.SERVICE_RM 'percona-master-${dc}-${uniqueId}' />
        <@swarm.SERVICE_RM 'percona-proxy-${dc}-${uniqueId}' />
        <@swarm.NETWORK_RM 'percona-${dc}-${uniqueId}' />
        sleep 30
      </#fi>
    </@cloud.DATACENTER>
  </#list>

  <@swarm.NETWORK_RM 'percona-net-${uniqueId}' />
</@requirement.CONFORMS>
