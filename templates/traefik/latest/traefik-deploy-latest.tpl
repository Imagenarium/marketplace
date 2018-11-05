<@requirement.PARAM name='PUBLISHED_PROXY_PORT' type='port' required='false' />
<@requirement.PARAM name='PUBLISHED_ADMIN_PORT' type='port' required='false' />

<@requirement.CONFORMS>
  <@swarm.NETWORK 'traefik-net-${namespace}' />

  <@swarm.SERVICE 'traefik-${namespace}' 'traefik:latest' '--docker --docker.swarmMode --docker.watch --api'>
    <@node.MANAGER />
    <@service.SCALABLE />
    <@service.SINGLE_INSTANCE_PER_NODE />
    <@service.NETWORK 'traefik-net-${namespace}' />
    <@service.PORT PARAMS.PUBLISHED_PROXY_PORT '80' />
    <@service.PORT PARAMS.PUBLISHED_ADMIN_PORT '8080' />
  </@swarm.SERVICE>
  
  <@docker.HTTP_CHECKER 'traefik-checker-${namespace}' 'http://traefik-${namespace}:8081/dashboard/' 'traefik-net-${namespace}' '1' />
</@requirement.CONFORMS>
