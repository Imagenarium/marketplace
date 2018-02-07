<@requirement.CONS 'percona' 'rack1' />
<@requirement.CONS 'percona' 'rack2' />
<@requirement.CONS 'percona' 'rack3' />

<@requirement.PARAM name='NEW_CLUSTER' value='false' type='boolean' />
<@requirement.PARAM name='NETWORK_DRIVER' value='overlay' values='weave:latest,overlay' type='select' />
<@requirement.PARAM name='VOLUME_DRIVER' value='local' values='vmware,do,aws,gce,azure,local' type='select' />
<@requirement.PARAM name='DATA_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='LOG_VOLUME_OPTS' value=' ' />
<@requirement.PARAM name='LIB_VOLUME_OPTS' value=' ' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='glusterfs-net-${namespace}' driver=PARAMS.NETWORK_DRIVER />  
    
  <#assign peers = [] />
  <#assign volumes = [] />
    
  <#list "1,2,3"?split(",") as rack>
    <#assign peers += ['glusterfs-rack${rack}-${namespace}.1'] />
    <#assign volumes += ['glusterfs-rack${rack}-${namespace}.1:/gluster-data'] />
  </#list>
  
  <@swarm.SERVICE 'swarmstorage-glusterfs-${namespace}' 'imagenarium/swarmstorage:0.5.0'>
    <@service.NETWORK 'glusterfs-net-${namespace}' />
    <@node.MANAGER />
  </@swarm.SERVICE>
    
  <#list "1,2,3"?split(",") as rack>
    <@swarm.TASK 'glusterfs-rack${rack}-${namespace}' 'imagenarium/glusterfs:3.13u27'>
      <@container.NETWORK 'glusterfs-net-${namespace}' />
      <@container.VOLUME 'glusterfs-data-volume-rack${rack}-${namespace}' '/gluster-data' PARAMS.VOLUME_DRIVER PARAMS.DATA_VOLUME_OPTS?trim />
      <@container.VOLUME 'glusterfs-log-volume-rack${rack}-${namespace}' '/var/log/glusterfs' PARAMS.VOLUME_DRIVER PARAMS.LOG_VOLUME_OPTS?trim />
      <@container.VOLUME 'glusterfs-lib-volume-rack${rack}-${namespace}' '/var/lib/glusterd' PARAMS.VOLUME_DRIVER PARAMS.LIB_VOLUME_OPTS?trim />
      <#if rack?number == 3>
      <@container.ENV 'BUILD_NODE' 'true' />
      </#if>
      <@container.ENV 'PEERS' peers?join(" ") />
      <@container.ENV 'VOLUME_DRIVER' PARAMS.VOLUME_DRIVER />
      <@container.ENV 'VOLUMES' volumes?join(" ") />
      <@container.ENV 'VOLUMES_COUNT' volumes?size />
      <@container.ENV 'NEW_CLUSTER' PARAMS.NEW_CLUSTER />
      <@container.ENV 'STORAGE_SERVICE' 'swarmstorage-glusterfs-${namespace}' />
    </@swarm.TASK>

    <@swarm.TASK_RUNNER 'glusterfs-rack${rack}-${namespace}'>
      <@service.CONS 'node.labels.glusterfs' 'rack${rack}' />
    </@swarm.TASK_RUNNER>
  </#list>

  <@docker.HTTP_CHECK 'http://glusterfs-rack3-${namespace}.1:9200?action=check' 'glusterfs-net-${namespace}' />
</@requirement.CONFORMS>