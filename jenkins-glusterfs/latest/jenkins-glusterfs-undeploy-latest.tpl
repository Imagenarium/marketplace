<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'jenkins-master-${namespace}' />
  <@swarm.SERVICE_RM 'jenkins-slave-${namespace}' />

  sleep 5
  <@swarm.NETWORK_RM 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>