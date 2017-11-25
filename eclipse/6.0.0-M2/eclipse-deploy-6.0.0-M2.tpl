<@requirement.PARAM 'PUBLISHED_PORT' '7777' />

<@requirement.CONFORMS>
  <@docker.CONTAINER 'eclipse-${uniqueId}' 'eclipse/che:6.0.0-M2' 'start'>
    <@container.DOCKER_SOCKET />
    <@container.VOLUME_OLD '/root/che' '/data' />
    <@container.ENV 'CHE_PORT' PARAMS.PUBLISHED_PORT />
  </@docker.CONTAINER>
</@requirement.CONFORMS>
