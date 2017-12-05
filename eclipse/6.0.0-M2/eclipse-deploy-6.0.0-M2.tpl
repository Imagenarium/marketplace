<@requirement.PARAM name='PUBLISHED_PORT' value='7777' type='number' />
<@requirement.NAMESPACE 'system' />

<@requirement.CONFORMS>
  <@docker.CONTAINER 'eclipse-${namespace}' 'eclipse/che:6.0.0-M2' 'start'>
    <@container.DOCKER_SOCKET />
    <@container.VOLUME_OLD '/root/che' '/data' />
    <@container.ENV 'CHE_PORT' PARAMS.PUBLISHED_PORT />
  </@docker.CONTAINER>
</@requirement.CONFORMS>
