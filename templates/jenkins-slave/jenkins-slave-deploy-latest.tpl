<@requirement.NAMESPACE 'jenkins' />

<@requirement.CONSTRAINT 'jenkins' 'slave' />

<@requirement.PARAM name='JENKINS_USER' value='admin' />
<@requirement.PARAM name='JENKINS_PASSWORD' value='admin' type='password' />
<@requirement.PARAM name='JAVA_OPTS' value='-Xmx512m' />
<@requirement.PARAM name='EXECUTORS' value='2' />
<@requirement.PARAM name='LABELS' value='default' />

<@swarm.SERVICE 'jenkins-slave-${namespace}' 'imagenarium/jenkins-slave:3.15'>
  <@service.SCALABLE />
  <@service.SINGLE_INSTANCE_PER_NODE />
  <@service.NETWORK 'jenkins-net-${namespace}' />
  <@service.DNSRR />
  <@service.CONSTRAINT 'jenkins' 'slave' />
  <@service.ENV 'JENKINS_MASTER' 'http://jenkins-${namespace}:8080' />
  <@service.ENV 'JAVA_OPTS' PARAMS.JAVA_OPTS />
  <@service.ENV 'EXECUTORS' PARAMS.EXECUTORS />
  <@service.ENV 'LABELS' PARAMS.LABELS />
  <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
  <@service.ENV 'JENKINS_PASSWORD' PARAMS.JENKINS_PASSWORD />
</@swarm.SERVICE>
