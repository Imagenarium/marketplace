<@requirement.CONSTRAINT 'gitlab-runner' 'true' />

<@requirement.PARAM name='CI_SERVER_URL' value='https://gitlab.com' />
<@requirement.PARAM name='REGISTRATION_TOKEN' value='' />
<@requirement.PARAM name='RUNNER_EXECUTOR' value='docker' values='shell,docker' type='select' />

<@swarm.SERVICE 'gitlab-runner-${namespace}' 'imagenarium/gitlab-runner:latest'>
  <@service.CONSTRAINT 'gitlab-runner' 'true' />
  <@service.ENV 'CI_SERVER_URL' PARAMS.CI_SERVER_URL />
  <@service.ENV 'REGISTRATION_TOKEN' PARAMS.REGISTRATION_TOKEN />
  <@service.ENV 'RUNNER_EXECUTOR' PARAMS.RUNNER_EXECUTOR />
</@swarm.SERVICE>
