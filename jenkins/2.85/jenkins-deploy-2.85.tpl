<@requirement.PARAM 'dc' />
<@requirement.SECRET 'settings.xml' />
<@requirement.SECRET 'jenkins-user' />
<@requirement.SECRET 'jenkins-pass' />
<@requirement.SECRET 'jenkins-github-owner' />
<@requirement.SECRET 'jenkins-github-repos' />
<@requirement.SECRET 'jenkins-github-token' />

<#if requirement.p.dc??>
  <@requirement.CONS 'jenkins' 'master' requirement.p.dc />
</#if>

<@swarm.NETWORK 'jenkins-net' />

<@swarm.SERVICE 'jenkins-master' 'imagenarium/jenkins:2.85'>
  <@service.NETWORK 'jenkins-net' />
  <@service.DOCKER_SOCKET />
  <@service.DC requirement.p.dc />
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
