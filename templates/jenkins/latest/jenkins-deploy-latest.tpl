<@requirement.NAMESPACE 'ci' />

<@requirement.CONS 'jenkins' 'master' />

<@requirement.PARAM name='PUBLISHED_PORT' value='4444' type='port' />
<@requirement.PARAM name='DELETE_DATA' value='false' type='boolean' />
<@requirement.PARAM name='JENKINS_USER' value='admin' />
<@requirement.PARAM name='JENKINS_PASSWORD' value='admin' type='password' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='jenkins-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <@swarm.STORAGE 'swarmstorage-jenkins-${namespace}' 'jenkins-net-${namespace}' />

  <@swarm.SERVICE 'jenkins-master-${namespace}' 'imagenarium/jenkins:2.131'>
    <@service.NETWORK 'jenkins-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.VOLUME 'jenkins-master-volume-${namespace}' '/var/jenkins_home' />
    <@service.SINGLE_INSTANCE_PER_NODE 'jenkins-${namespace}' />
    <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-jenkins-${namespace}' />
    <@service.ENV 'DELETE_DATA' PARAMS.DELETE_DATA />
    <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
    <@service.ENV 'JENKINS_PASSWORD' PARAMS.JENKINS_PASSWORD />
    <@service.CONS 'node.labels.jenkins' 'master' />
  </@swarm.SERVICE>

  <@swarm.SERVICE 'jenkins-slave-${namespace}' 'imagenarium/jenkins-slave:3.10'>
    <@service.SCALABLE />
    <@service.REPLICAS '0' />
    <@service.SINGLE_INSTANCE_PER_NODE 'jenkins-${namespace}' />
    <@service.NETWORK 'jenkins-net-${namespace}' />
    <@service.ENV 'JENKINS_MASTER' 'http://jenkins-master-${namespace}.1:8080' />
    <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
    <@service.ENV 'JENKINS_PASSWORD' PARAMS.JENKINS_PASSWORD />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECKER 'jenkins-checker-${namespace}' 'http://jenkins-master-${namespace}.1:8080' 'jenkins-net-${namespace}' />
</@requirement.CONFORMS>