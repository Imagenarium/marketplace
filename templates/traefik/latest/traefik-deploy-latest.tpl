<@requirement.CONSTRAINT 'traefik' 'true' />

<@requirement.PARAM name='PUBLISHED_PROXY_PORT' type='port' required='false' />
<@requirement.PARAM name='PUBLISHED_ADMIN_PORT' type='port' required='false' />

<@swarm.SERVICE 'traefik-${namespace}' 'traefik:alpine' "--logLevel=INFO --metrics.prometheus --docker --docker.swarmMode --docker.watch --api --constraints='tag==${namespace}'">
  <@node.MANAGER />
  <@service.SCALABLE />
  <@service.SINGLE_INSTANCE_PER_NODE />
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'traefik' 'true' />
  <@service.PORT PARAMS.PUBLISHED_PROXY_PORT '80' />
  <@service.PORT PARAMS.PUBLISHED_ADMIN_PORT '8080' />
  <@service.CHECK_PATH ':8080/dashboard/' />
  <@service.ENV 'METRICS_ENDPOINT' ':8080/metrics' />
</@swarm.SERVICE>
