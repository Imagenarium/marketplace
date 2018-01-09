<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'jenkins-master-${namespace}' />
  <@swarm.SERVICE_RM 'jenkins-slave-${namespace}' />
  <@swarm.NETWORK_RM 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>