<@requirement.CONFORMS>
<#--  <@swarm.SERVICE_RM 'glusterfs-client-${namespace}' />-->

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'glusterfs-${dc}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'swarmstorage-glusterfs-${namespace}' />

  sleep 5
  <@swarm.NETWORK_RM 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>
