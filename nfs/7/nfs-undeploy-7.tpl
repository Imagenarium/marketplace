<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'nfs-filestorage-${namespace}' />
  <@swarm.SERVICE_RM 'nfs-temp-${namespace}' />
  <@swarm.SERVICE_RM 'swarmstorage-nfs-${namespace}' />
  <@swarm.NETWORK_RM 'sylex-net-${namespace}' />
</@requirement.CONFORMS>
