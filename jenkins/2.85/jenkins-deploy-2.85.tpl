<@requirement.PARAM 'GITHUB_OWNER' />
<@requirement.PARAM 'GITHUB_REPOS' />
<@requirement.PARAM 'PUBLISHED_PORT' />
<@requirement.PARAM 'JENKINS_USER' 'admin' />

<@requirement.NAMESPACE 'system' />

<@requirement.SECRET 'settings.xml' />
<@requirement.SECRET 'jenkins-pass' />
<@requirement.SECRET 'jenkins-github-token' />

<@requirement.CONS 'jenkins' 'master' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'jenkins-net-${namespace}' />

  <@swarm.SERVICE 'jenkins-master-${namespace}' 'imagenarium/jenkins:2.85'>
    <@service.NETWORK 'jenkins-net-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
    <@service.CONS 'node.labels.jenkins' 'master' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
    <@service.ENV 'GITHUB_OWNER' PARAMS.GITHUB_OWNER />
    <@service.ENV 'GITHUB_REPOS' PARAMS.GITHUB_REPOS />
    <@service.SECRET 'settings.xml' />
    <@service.SECRET 'jenkins-pass' />
    <@service.SECRET 'jenkins-github-token' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'jenkins-slave-${namespace}' 'imagenarium/jenkins-slave:3.4' 'global'>
    <@service.NETWORK 'jenkins-net-${namespace}' />
    <@node.MANAGER />
    <@service.DOCKER_SOCKET />
    <@service.CONS 'node.labels.jenkins' 'slave' />
    <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
    <@service.SECRET 'jenkins-pass' />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECK 'http://jenkins-master-${namespace}:8080' 'jenkins-net-${namespace}' />
</@requirement.CONFORMS>
