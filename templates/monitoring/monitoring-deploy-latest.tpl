<@requirement.NAMESPACE 'monitoring' />

<@requirement.PARAM name='ADMIN_USER' value='admin' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='admin' />

<@requirement.PARAM name='GRAFANA_PUBLISHED_PORT'        value='3000'   type='port' />
<@requirement.PARAM name='ALERTDASHBOARD_PUBLISHED_PORT' value='9094'   type='port' />

<@requirement.CONSTRAINT 'monitoring' 'true' />

<@swarm.SERVICE 'cadvisor-${namespace}' 'google/cadvisor' '' 'global'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.BIND '/' '/rootfs' />
  <@service.BIND '/var/run' '/var/run' />
  <@service.BIND '/sys' '/sys' />
  <@service.BIND '/var/lib/docker/' '/var/lib/docker/' />
  <@service.BIND '/dev/disk/' '/dev/disk/' />
</@swarm.SERVICE>

<@swarm.SERVICE 'node-exporter-${namespace}' 'imagenarium/node-exporter:v0.17.0' '--path.rootfs /rootfs --collector.textfile.directory=/etc/node-exporter/ --no-collector.ipvs' 'global'>
  <@service.NETWORK 'net-${namespace}' />  
  <@service.ENV 'NODE_ID' '{{.Node.ID}}' />
  <@service.BIND '/' '/rootfs' />
  <@service.BIND '/etc/hostname' '/etc/nodename' />
</@swarm.SERVICE>

<@swarm.SERVICE 'alertmanager-${namespace}' 'prom/alertmanager:v0.15.3'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT ALERTDASHBOARD_PUBLISHED_PORT '9094' />
  <@service.CONSTRAINT 'monitoring' 'true' />
</@swarm.SERVICE>

<@swarm.SERVICE 'prometheus-${namespace}' 'imagenarium/prometheus:v2.5.0' '--storage.tsdb.retention=24h'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'monitoring' 'true' />
  <@service.CHECK_PORT '9090' />
</@swarm.SERVICE>

<@swarm.SERVICE 'grafana-${namespace}' 'imagenarium/grafana:5.3.4'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT GRAFANA_PUBLISHED_PORT '3000' />
  <@service.ANONYMOUS_VOLUME '/var/lib/grafana' />
  <@service.CONSTRAINT 'monitoring' 'true' />
  <@service.ENV 'GF_SECURITY_ADMIN_USER' PARAMS.ADMIN_USER />
  <@service.ENV 'GF_SECURITY_ADMIN_PASSWORD' PARAMS.ADMIN_PASSWORD />
  <@service.ENV 'GF_USERS_ALLOW_SIGN_UP' 'false' />
  <@service.CHECK_PORT '3000' />
</@swarm.SERVICE>
