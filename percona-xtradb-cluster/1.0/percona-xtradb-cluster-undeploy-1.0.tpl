<@swarm.SERVICE_RM 'percona-init' />

<@node.DATACENTER ; dc, index, isLast>
  <@swarm.SERVICE_RM 'percona-master-${dc}' />
  <@swarm.SERVICE_RM 'percona-proxy-${dc}' />
  <@swarm.NETWORK_RM 'percona-${dc}' />
</@node.DATACENTER>

<@swarm.NETWORK_RM 'percona-net' />
<@swarm.NETWORK_RM 'haproxy-monitoring' />

<@node.NODE_BY_LABEL 'db'; hostname, value, index, isLast>
  <#if value == 'percona'>  
    <@node.LABEL_RM hostname 'db' />
  </#if>
</@node.NODE_BY_LABEL>