<@bash.PROFILE>  
  <@swarm.NETWORK 'etcd-net' />
  
  <#assign seeds = [] />
  
  <@node.DATACENTER ; dc, index, isLast>
    <#assign seeds += ['etcd-${dc}=http://etcd-${dc}:2380'] />
  </@node.DATACENTER>
  
  <@node.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'etcd-${dc}' 'quay.io/coreos/etcd' '/usr/local/bin/etcd --name etcd-${dc} --listen-client-urls http://0.0.0.0:2379 --advertise-client-urls http://etcd-${dc}:2379 --listen-peer-urls http://0.0.0.0:2380 --initial-advertise-peer-urls http://etcd-${dc}:2380 --initial-cluster ${seeds?join(",")} --initial-cluster-token etcd-cluster --initial-cluster-state new --auto-compaction-retention 1'>
      <@service.PORT '2379' '2379' />
      <@service.NETWORK 'etcd-net' />
      <@service.DNSRR />
      <@service.DC dc />
    </@swarm.SERVICE>
  </@node.DATACENTER>
</@bash.PROFILE>