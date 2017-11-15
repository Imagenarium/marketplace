<@requirement.PARAM 'PORT' />

<@requirement.CONFORMS>
  <@docker.CONTAINER 'eclipse-${uniqueId}' 'eclipse/che:5.20.0' 'start'>
    <@container.DOCKER_SOCKET />
    <@container.VOLUME_OLD '/root/che' '/data' />
    <@container.ENV 'CHE_PORT' PARAMS.PORT />
  </@docker.CONTAINER>
</@requirement.CONFORMS>
