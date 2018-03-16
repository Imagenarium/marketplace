<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'gluster-checker-${namespace}' />

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'glusterfs-${index}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.SERVICE_RM 'swarmstorage-glusterfs-${namespace}' />
  <@swarm.NETWORK_RM 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>
