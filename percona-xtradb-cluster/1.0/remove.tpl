<@bash.HEADER />

<@swarm.SERVICE_RM 'percona-init' />

<@node.UNIQUE_VALUES 'dc' ; labelValue, index, isLast>
  <@swarm.SERVICE_RM 'percona-master-${labelValue}' />
  <@swarm.SERVICE_RM 'percona-proxy-${labelValue}' />
  <@swarm.NETWORK_RM 'percona-${labelValue}' />
</@node.UNIQUE_VALUES>

<@swarm.NETWORK_RM 'percona-net' />
<@swarm.NETWORK_RM 'haproxy-monitoring' />

<@node.HOSTNAME_2_VALUE 'db'; hostname, labelValue, index, isLast>
  <#if labelValue == 'percona'>  
    <@node.LABEL_RM hostname 'db' />
  </#if>
</@node.HOSTNAME_2_VALUE>