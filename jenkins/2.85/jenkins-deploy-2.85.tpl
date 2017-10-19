<@requirement.PARAM 'dc' />

<#if params.dc??>
  <@requirement.CONS 'jenkins' 'master' params.dc />
</#if>

<@swarm.NETWORK 'jenkins-net' />

<@swarm.SERVICE 'jenkins-master' 'imagenarium/jenkins:2.85'>
  <@service.NETWORK 'jenkins-net' />
  <@service.DOCKER_SOCKET />
  <@service.DC params.dc />
  <@service.CONS 'node.labels.jenkins' 'master' />
  <@service.PORT '7070' '8080' />
  <@service.SECRET 'settings.xml' '/credentials/settings.xml' />
  <@service.SECRET 'jenkins-user' />
  <@service.SECRET 'jenkins-pass' />
  <@service.SECRET 'jenkins-github-owner' />
  <@service.SECRET 'jenkins-github-repos' />
  <@service.SECRET 'jenkins-github-token' />
</@swarm.SERVICE>

<@swarm.SERVICE 'jenkins-slave' 'imagenarium/jenkins-slave:3.4' 'global'>
  <@service.NETWORK 'jenkins-net' />
  <@service.CONS 'node.labels.jenkins' 'slave' />
  <@service.DOCKER_SOCKET />
  <@service.SECRET 'jenkins-user' />
  <@service.SECRET 'jenkins-pass' />
</@swarm.SERVICE>
