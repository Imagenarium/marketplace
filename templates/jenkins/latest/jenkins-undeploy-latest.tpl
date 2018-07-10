<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'kenkins-checker-${namespace}' />

  <@swarm.SERVICE_RM 'swarmstorage-jenkins-${namespace}' />
  <@swarm.SERVICE_RM 'jenkins-master-${namespace}' />
  <@swarm.SERVICE_RM 'jenkins-slave-${namespace}' />

  <@swarm.NETWORK_RM 'jenkins-net-${namespace}' />
</@requirement.CONFORMS>