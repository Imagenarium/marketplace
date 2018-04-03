<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'kibana-checker-${namespace}' />

  <@swarm.SERVICE_RM 'jenkins-master-${namespace}' />
  <@swarm.SERVICE_RM 'jenkins-slave-${namespace}' />
  <@swarm.NETWORK_RM 'glusterfs-net-${namespace}' />
  <@swarm.NETWORK_RM 'jenkins-net-${namespace}' />
</@requirement.CONFORMS>