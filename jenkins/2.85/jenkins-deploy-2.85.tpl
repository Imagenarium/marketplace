<@requirement.PARAM 'GITHUB_OWNER' />
<@requirement.PARAM 'GITHUB_REPOS' />
<@requirement.PARAM 'JENKINS_PORT' />
<@requirement.PARAM 'JENKINS_USER' 'admin' />
<@requirement.PARAM 'uniqueId' />

<@requirement.SECRET 'settings.xml' />
<@requirement.SECRET 'jenkins-pass' />
<@requirement.SECRET 'jenkins-github-token' />

<@requirement.CONS 'jenkins' 'master' />

<@swarm.NETWORK 'jenkins-net-${uniqueId}' />

<@swarm.SERVICE 'jenkins-master-${uniqueId}' 'imagenarium/jenkins:2.85'>
  <@service.NETWORK 'jenkins-net-${uniqueId}' />
  <@node.MANAGER />
  <@service.DOCKER_SOCKET />
  <@service.CONS 'node.labels.jenkins' 'master' />
  <@service.PORT PARAMS.JENKINS_PORT '8080' />
  <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
  <@service.ENV 'GITHUB_OWNER' PARAMS.GITHUB_OWNER />
  <@service.ENV 'GITHUB_REPOS' PARAMS.GITHUB_REPOS />
  <@service.SECRET 'settings.xml' />
  <@service.SECRET 'jenkins-pass' />
  <@service.SECRET 'jenkins-github-token' />
</@swarm.SERVICE>

<@swarm.SERVICE 'jenkins-slave-${uniqueId}' 'imagenarium/jenkins-slave:3.4' 'global'>
  <@service.NETWORK 'jenkins-net-${uniqueId}' />
  <@node.MANAGER />
  <@service.CONS 'node.labels.jenkins' 'slave' />
  <@service.DOCKER_SOCKET />
  <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
  <@service.SECRET 'jenkins-pass' />
</@swarm.SERVICE>
