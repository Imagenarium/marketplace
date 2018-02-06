<@requirement.CONFORMS>
  <@docker.CONTAINER_RM 'percona-node-checker-${namespace}' />
  <@swarm.SERVICE_RM 'percona-init-${namespace}' />

  <@cloud.DATACENTER reverse=true ; dc, index, isLast>
    <@swarm.SERVICE_RM 'percona-master-${dc}-${namespace}' />
    <@swarm.SERVICE_RM 'percona-proxy-${dc}-${namespace}' />
    <@swarm.NETWORK_RM 'percona-${dc}-${namespace}' />
  </@cloud.DATACENTER>

  <@swarm.NETWORK_RM 'percona-net-${namespace}' />
</@requirement.CONFORMS>
