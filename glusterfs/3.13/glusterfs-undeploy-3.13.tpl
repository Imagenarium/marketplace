<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'glusterfs-${dc}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'swarmstorage-glusterfs-${namespace}' />

  sleep 10
  <@swarm.NETWORK_RM 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>
