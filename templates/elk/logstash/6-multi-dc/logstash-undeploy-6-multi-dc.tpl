<@requirement.CONFORMS>
  <@docker.REMOVE_HTTP_CHECKER 'logstash-checker-${namespace}' />

  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'logstash-${dc}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.NETWORK_RM 'es-net-${namespace}' />
</@requirement.CONFORMS>