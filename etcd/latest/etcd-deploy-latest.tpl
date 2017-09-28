<@bash.PROFILE>  
  <#assign HAPROXY_VERSION='1.6.7' />

  <@swarm.NETWORK 'etcd-net' />
  
  <#assign seeds = [] />
  
  <@node.DATACENTER ; dc, index, isLast>
    <#assign seeds += ['etcd-${dc}=http://etcd-${dc}:2380'] />
  </@node.DATACENTER>
  
  <@node.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'etcd-${dc}' 'quay.io/coreos/etcd' 'replicated' '/usr/local/bin/etcd --name etcd-${dc} --listen-client-urls http://0.0.0.0:2379 --advertise-client-urls http://etcd-${dc}:2379 --listen-peer-urls http://0.0.0.0:2380 --initial-advertise-peer-urls http://etcd-${dc}:2380 --initial-cluster ${seeds?join(",")} --initial-cluster-token etcd-cluster --initial-cluster-state new --auto-compaction-retention 1'>
      <@service.NETWORK 'etcd-net' />
      <@service.DC dc />
      <@service.ENV 'SERVICE_PORTS' '2379' />
      <@service.ENV 'BALANCE' 'source' />
      <@service.ENV 'HEALTH_CHECK' 'check port 2379 inter 5000 rise 1 fall 2' />
      <@service.ENV 'OPTION' 'httpchk GET /version HTTP/1.1\\r\\nHost:\\ www' />
    </@swarm.SERVICE>
  </@node.DATACENTER>

  <@swarm.SERVICE 'etcd-proxy' 'dockercloud/haproxy:${HAPROXY_VERSION}'>
    <@service.NETWORK 'etcd-net' />
    <@service.DOCKER_SOCKET />
    <@node.MANAGER />
    <@service.PORT '2379' '80' />
  </@swarm.SERVICE>
</@bash.PROFILE>