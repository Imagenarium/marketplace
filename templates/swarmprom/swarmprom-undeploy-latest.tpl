<@swarm.SERVICE_RM 'dockerd-exporter-${namespace}' />
<@swarm.SERVICE_RM 'cadvisor-${namespace}' />
<@swarm.SERVICE_RM 'grafana-${namespace}' />
<@swarm.SERVICE_RM 'alertmanager-${namespace}' />
<@swarm.SERVICE_RM 'unsee-${namespace}' />
<@swarm.SERVICE_RM 'node-exporter-${namespace}' />
<@swarm.SERVICE_RM 'prometheus-${namespace}' />
<@swarm.SERVICE_RM 'caddy-${namespace}' />

<@swarm.NETWORK_RM 'net-${namespace}' />
