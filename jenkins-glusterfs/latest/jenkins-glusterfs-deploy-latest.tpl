<@requirement.NAMESPACE 'system' />

<@requirement.PARAM name='PUBLISHED_PORT' type='number' />
<@requirement.PARAM name='JENKINS_USER' value='admin' />
<@requirement.PARAM name='JENKINS_PASSWORD' value='admin' />

<@requirement.CONS_HA 'jenkins' 'master' />

<@requirement.CONFORMS>
  <#assign peers = [] />
    
  <@cloud.DATACENTER ; dc, index, isLast>
    <#assign peers += ['glusterfs-${dc}-${namespace}.1'] />
  </@cloud.DATACENTER>

  <@swarm.TASK 'jenkins-master-${namespace}' 'imagenarium/jenkins-glusterfs:2.95-slim-u1'>
    <@container.NETWORK 'glusterfs-net-${namespace}' />
    <@container.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@container.ENV 'PEERS' peers?join(" ") />
    <@container.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
    <@container.ENV 'JENKINS_PASSWORD' PARAMS.JENKINS_PASSWORD />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'jenkins-master-${namespace}'>
    <@service.CONS 'node.labels.jenkins' 'master' />
  </@swarm.TASK_RUNNER>

  <@swarm.SERVICE 'jenkins-slave-${namespace}' 'imagenarium/jenkins-slave:3.6' 'global'>
    <@service.NETWORK 'glusterfs-net-${namespace}' />
    <@service.DOCKER_SOCKET />
    <@service.CONS 'node.labels.jenkins' 'slave' />
    <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
    <@service.ENV 'JENKINS_PASSWORD' PARAMS.JENKINS_PASSWORD />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECK 'http://jenkins-master-${namespace}.1:8080' 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>