<@requirement.NAMESPACE 'jenkins' />

<@requirement.CONSTRAINT 'jenkins' 'master' />

<@requirement.PARAM name='PUBLISHED_PORT' value='4444' type='port' />
<@requirement.PARAM name='JENKINS_USER' value='admin' />
<@requirement.PARAM name='JENKINS_PASSWORD' value='admin' type='password' />

<@swarm.SERVICE 'jenkins-${namespace}' 'imagenarium/jenkins:latest'>
  <@service.VOLUME '/var/jenkins_home' />
  <@service.NETWORK 'jenkins-net-${namespace}' />
  <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
  <@service.CONSTRAINT 'jenkins' 'master' />
  <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
  <@service.ENV 'JENKINS_PASSWORD' PARAMS.JENKINS_PASSWORD />
  <@service.CHECK_PORT '8080' />
</@swarm.SERVICE>
