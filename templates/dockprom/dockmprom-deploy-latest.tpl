<@requirement.NAMESPACE 'dockprom' />

<@requirement.PARAM name='ADMIN_USER' value='admin' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='admin' />

<@requirement.PARAM name='GRAFANA_PUBLISHED_PORT'        value='3000'   type='port' />
<@requirement.PARAM name='ALERTDASHBOARD_PUBLISHED_PORT' value='9094'   type='port' />
<@requirement.PARAM name='PROMETHEUS_PUBLISHED_PORT'   required='false' type='port' />
<@requirement.PARAM name='ALERTMANAGER_PUBLISHED_PORT' required='false' type='port' />

<@requirement.CONSTRAINT 'dockprom' 'true' />

<@swarm.SERVICE 'cadvisor-${namespace}' 'google/cadvisor' '' 'global'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.BIND '/' '/rootfs' />
  <@service.BIND '/var/run' '/var/run' />
  <@service.BIND '/sys' '/sys' />
  <@service.BIND '/var/lib/docker/' '/var/lib/docker/' />
</@swarm.SERVICE>

<@swarm.SERVICE 'node-exporter-${namespace}' 'prom/node-exporter:v0.17.0' '--path.rootfs /rootfs --collector.textfile.directory=/etc/node-exporter/ --no-collector.ipvs' 'global'>
  <@service.NETWORK 'net-${namespace}' />  
  <@service.BIND '/' '/rootfs' />
</@swarm.SERVICE>

<@swarm.SERVICE 'alertmanager-${namespace}' 'prom/alertmanager:v0.15.3'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'dockprom' 'true' />
</@swarm.SERVICE>

<@swarm.SERVICE 'prometheus-${namespace}' 'imagenarium/dockprom-prometheus:v2.5.0' '--storage.tsdb.retention=24h'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'dockprom' 'true' />
</@swarm.SERVICE>

<@swarm.SERVICE 'grafana-${namespace}' 'imagenarium/dockprom-grafana:5.4.0'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.ANONYMOUS_VOLUME '/var/lib/grafana' />
  <@service.CONSTRAINT 'dockprom' 'true' />
  <@service.ENV 'GF_SECURITY_ADMIN_USER' PARAMS.ADMIN_USER />
  <@service.ENV 'GF_SECURITY_ADMIN_PASSWORD' PARAMS.ADMIN_PASSWORD />
  <@service.ENV 'GF_USERS_ALLOW_SIGN_UP' 'false' />
</@swarm.SERVICE>







<@swarm.SERVICE 'caddy-${namespace}' 'imagenarium/caddy'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.GRAFANA_PUBLISHED_PORT '3000' />
  <@service.PORT PARAMS.PROMETHEUS_PUBLISHED_PORT '9090' />
  <@service.PORT PARAMS.ALERTMANAGER_PUBLISHED_PORT '9093' />
  <@service.PORT PARAMS.ALERTDASHBOARD_PUBLISHED_PORT '9094' />
  <@service.ENV 'ADMIN_USER' PARAMS.ADMIN_USER />
  <@service.ENV 'ADMIN_PASSWORD' PARAMS.ADMIN_PASSWORD />
</@swarm.SERVICE>

<@docker.HTTP_CHECKER 'checker-${namespace}' 'http://caddy-${namespace}:3000/login' 'net-${namespace}' />
<@docker.HTTP_CHECKER 'checker-${namespace}' 'http://${PARAMS.ADMIN_USER}:${PARAMS.ADMIN_PASSWORD}@caddy-${namespace}:9090/metrics' 'net-${namespace}' />
