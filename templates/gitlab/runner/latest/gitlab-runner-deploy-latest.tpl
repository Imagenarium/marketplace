<@requirement.CONS 'gitlab-runner' 'true' />

<@requirement.PARAM name='GITLAB_URL' value='https://gitlab.com' />
<@requirement.PARAM name='RUNNER_TOKEN' value='' />
<@requirement.PARAM name='RUNNER_EXECUTOR' value='shell' values='shell,docker' type='select' />

<@requirement.CONFORMS>
  <@swarm.NETWORK name='gitlab-net-${namespace}' />

  <@swarm.SERVICE 'gitlab-runner-${namespace}' 'imagenarium/gitlab-runner:latest' 'replicated' 'register -n -u ${PARAMS.GITLAB_URL} -r ${PARAMS.RUNNER_TOKEN} --name gitlab-runner-${namespace} --executor ${PARAMS.RUNNER_EXECUTOR}'>
    <@service.NETWORK 'gitlab-net-${namespace}' />
    <@service.CONS 'node.labels.gitlab-runner' 'true' />
    <@service.VOLUME 'gitlab-runner-volume-${namespace}' '/home/gitlab-runner' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>