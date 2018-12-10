<@swarm.SERVICE_RM 'cadvisor-${namespace}' />
<@swarm.SERVICE_RM 'node-exporter-${namespace}' />
<@swarm.SERVICE_RM 'alertmanager-${namespace}' />
<@swarm.SERVICE_RM 'prometheus-${namespace}' />
<@swarm.SERVICE_RM 'grafana-${namespace}' />
<@swarm.NETWORK_RM 'net-${namespace}' />
