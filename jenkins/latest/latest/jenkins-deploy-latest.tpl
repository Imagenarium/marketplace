<@swarm.NETWORK 'jenkins-net' />

<@swarm.SERVICE 'jenkins-master' 'imagenarium/jenkins'>
  <@service.NETWORK 'jenkins-net' />
  <@service.DOCKER_SOCKET />
  <@service.PORT '7070' '8080' />
  <@service.SECRET 'settings.xml' '/credentials/settings.xml' />
  <@service.SECRET 'jenkins-user' />
  <@service.SECRET 'jenkins-pass' />
  <@service.SECRET 'jenkins-github-owner' />
  <@service.SECRET 'jenkins-github-repos' />
  <@service.SECRET 'jenkins-github-token' />
</@swarm.SERVICE>

<@swarm.SERVICE 'jenkins-slave' 'imagenarium/jenkins-slave:3.4'>
  <@service.NETWORK 'jenkins-net' />
  <@service.DOCKER_SOCKET />
  <@service.SECRET 'jenkins-user' />
  <@service.SECRET 'jenkins-pass' />
</@swarm.SERVICE>
