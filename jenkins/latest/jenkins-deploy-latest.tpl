<@requirement.CONS 'jenkins' 'master' />

<@requirement.PARAM name='PUBLISHED_PORT' value='4444' type='number' />
<@requirement.PARAM name='JENKINS_USER' value='admin' />
<@requirement.PARAM name='JENKINS_PASSWORD' value='admin' type='password' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' type='network_driver' />
<@requirement.PARAM name='USE_GLUSTER' value='false' type='boolean' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='jenkins-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />

  <#assign peers = [] />
    
  <#list 1..3 as index>
    <#assign peers += ['glusterfs-${index}-${namespace}.1'] />
  </#list>

  <@swarm.TASK 'jenkins-master-${namespace}'>
    <@container.NETWORK 'jenkins-net-${namespace}' />
    <#if PARAMS.USE_GLUSTER == 'true'>
      <@container.NETWORK 'glusterfs-net-${namespace}' />
      <@container.ENV 'GLUSTER_PEERS' peers?join(" ") />
      <@container.ENV 'USE_GLUSTER' 'true' />
    <#else>
      <@container.VOLUME 'jenkins-master-volume-${namespace}' '/var/jenkins_home' />
    </#if>
    <@container.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
    <@container.ENV 'JENKINS_PASSWORD' PARAMS.JENKINS_PASSWORD />
  </@swarm.TASK>

  <@swarm.TASK_RUNNER 'jenkins-master-${namespace}' 'imagenarium/jenkins-glusterfs:2.109-slim_1'>
    <@service.PORT_MUTEX '13331' />
    <@service.CONS 'node.labels.jenkins' 'master' />
    <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
    <@service.ENV 'SERVICE_PORTS' '8080' />  
  </@swarm.TASK_RUNNER>

  <@swarm.SERVICE 'jenkins-slave-${namespace}' 'imagenarium/jenkins-slave:3.10'>
    <@service.SCALABLE />
    <@service.REPLICAS '0' />
    <@service.PORT_MUTEX '13331' />
    <@service.NETWORK 'jenkins-net-${namespace}' />
    <@service.ENV 'JENKINS_MASTER' 'http://jenkins-master-${namespace}.1:8080' />
    <@service.ENV 'JENKINS_USER' PARAMS.JENKINS_USER />
    <@service.ENV 'JENKINS_PASSWORD' PARAMS.JENKINS_PASSWORD />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECKER 'jenkins-checker-${namespace}' 'http://jenkins-master-${namespace}.1:8080' 'jenkins-net-${namespace}' />
</@requirement.CONFORMS>