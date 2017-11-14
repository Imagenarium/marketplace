<@requirement.PARAM 'GITHUB_OWNER' />
<@requirement.PARAM 'GITHUB_REPOS' />
<@requirement.PARAM 'JENKINS_PORT' />
<@requirement.PARAM 'SETTINGS_XML' />

<#if SETTINGS_XML??>
  <@requirement.SECRET '${SETTINGS_XML}' />
</#if>

<@requirement.SECRET 'jenkins-pass' />
<@requirement.SECRET 'jenkins-github-token' />

<@requirement.CONS 'jenkins' 'master' />

<@swarm.NETWORK 'jenkins-net' />

<@swarm.SERVICE 'jenkins-master' 'imagenarium/jenkins:2.85'>
  <@service.NETWORK 'jenkins-net' />
  <@node.MANAGER />
  <@service.DOCKER_SOCKET />
  <@service.CONS 'node.labels.jenkins' 'master' />
  <@service.PORT JENKINS_PORT '8080' />
  <@service.ENV 'JENKINS_USER' 'admin' />
  <@service.ENV 'GITHUB_OWNER' GITHUB_OWNER />
  <@service.ENV 'GITHUB_REPOS' GITHUB_REPOS />
  <@service.SECRET 'settings.xml' '/credentials/settings.xml' />
  <@service.SECRET 'jenkins-pass' />
  <@service.SECRET 'jenkins-github-token' />
</@swarm.SERVICE>

<@swarm.SERVICE 'jenkins-slave' 'imagenarium/jenkins-slave:3.4' 'global'>
  <@service.NETWORK 'jenkins-net' />
  <@node.MANAGER />
  <@service.CONS 'node.labels.jenkins' 'slave' />
  <@service.DOCKER_SOCKET />
  <@service.ENV 'JENKINS_USER' 'admin' />
  <@service.SECRET 'jenkins-pass' />
</@swarm.SERVICE>
