<@requirement.NAMESPACE 'swarmprom' />

<@requirement.PARAM name='ADMIN_USER' value='admin' />
<@requirement.PARAM name='ADMIN_PASSWORD' value='admin' />

<@requirement.PARAM name='GRAFANA_PUBLISHED_PORT'        value='3000'   type='port' />
<@requirement.PARAM name='ALERTDASHBOARD_PUBLISHED_PORT' value='9094'   type='port' />
<@requirement.PARAM name='PROMETHEUS_PUBLISHED_PORT'   required='false' type='port' />
<@requirement.PARAM name='ALERTMANAGER_PUBLISHED_PORT' required='false' type='port' />

<@requirement.CONSTRAINT 'swarmprom' 'true' />

<@swarm.SERVICE 'dockerd-exporter-${namespace}' 'imagenarium/caddy' '' 'global'>
  <@service.NETWORK 'net-${namespace}' />
</@swarm.SERVICE>

<@swarm.SERVICE 'cadvisor-${namespace}' 'google/cadvisor' '-logtostderr -docker_only' 'global'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.BIND '/' '/rootfs' />
  <@service.BIND '/var/run' '/var/run' />
  <@service.BIND '/sys' '/sys' />
  <@service.BIND '/var/lib/docker/' '/var/lib/docker/' />
</@swarm.SERVICE>

<@swarm.SERVICE 'grafana-${namespace}' 'imagenarium/swarmprom-grafana:5.3.4'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.ANONYMOUS_VOLUME '/var/lib/grafana' />
  <@service.CONSTRAINT 'swarmprom' 'true' />
  <@node.MANAGER />
  <@service.ENV 'GF_SECURITY_ADMIN_USER' PARAMS.ADMIN_USER />
  <@service.ENV 'GF_SECURITY_ADMIN_PASSWORD' PARAMS.ADMIN_PASSWORD />
  <@service.ENV 'GF_USERS_ALLOW_SIGN_UP' 'false' />
</@swarm.SERVICE>

<@swarm.SERVICE 'alertmanager-${namespace}' 'prom/alertmanager:v0.15.3'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'swarmprom' 'true' />
  <@node.MANAGER />
</@swarm.SERVICE>

<@swarm.SERVICE 'unsee-${namespace}' 'cloudflare/unsee:v0.8.0'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.ENV 'ALERTMANAGER_URIS' 'default:http://alertmanager-${namespace}:9093' />
</@swarm.SERVICE>

<@swarm.SERVICE 'node-exporter-${namespace}' 'stefanprodan/swarmprom-node-exporter:v0.16.0' "'--path.sysfs=/host/sys --path.procfs=/host/proc --collector.textfile.directory=/etc/node-exporter/ --collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($$|/) --no-collector.ipvs'" 'global'>
  <@service.NETWORK 'net-${namespace}' />  
  <@service.ENV 'NODE_ID' '{{.Node.ID}}' />
  <@service.BIND '/proc' '/host/proc' />
  <@service.BIND '/sys' '/host/sys' />
  <@service.BIND '/' '/rootfs' />
  <@service.BIND '/etc/hostname' '/etc/nodename' />
</@swarm.SERVICE>

<@swarm.SERVICE 'prometheus-${namespace}' 'imagenarium/swarmprom-prometheus:v2.5.0' '--config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus --storage.tsdb.retention=24h'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.CONSTRAINT 'swarmprom' 'true' />
  <@node.MANAGER />
</@swarm.SERVICE>

<@swarm.SERVICE 'caddy-${namespace}' 'imagenarium/caddy'>
  <@service.NETWORK 'net-${namespace}' />
  <@service.PORT PARAMS.GRAFANA_PUBLISHED_PORT '3000' />
  <@service.PORT PARAMS.PROMETHEUS_PUBLISHED_PORT '9090' />
  <@service.PORT PARAMS.ALERTMANAGER_PUBLISHED_PORT '9093' />
  <@service.PORT PARAMS.ALERTDASHBOARD_PUBLISHED_PORT '9094' />
  <@service.ENV 'ADMIN_USER' PARAMS.ADMIN_USER />
  <@service.ENV 'ADMIN_PASSWORD' PARAMS.ADMIN_PASSWORD />
  <@node.MANAGER />
</@swarm.SERVICE>

<@docker.HTTP_CHECKER 'checker-${namespace}' 'http://caddy-${namespace}:3000/login' 'net-${namespace}' />
<@docker.HTTP_CHECKER 'checker-${namespace}' 'http://caddy-${namespace}:9090' 'net-${namespace}' />
