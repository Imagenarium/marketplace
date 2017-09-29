<@bash.PROFILE>  
  <@swarm.NETWORK 'minio-net' />
  
  <#assign seeds = [] />
  
  <@node.DATACENTER ; dc, index, isLast>
    <#list 1..2 as i>
      <#assign seeds += ['http://minio-${dc}-${i}/export'] />
    </#list>
  </@node.DATACENTER>
  
  <@node.DATACENTER ; dc, index, isLast>
    <#list 1..2 as i>
      <@swarm.SERVICE 'minio-${dc}-${i}' 'minio/minio' 'replicated' 'server seeds?join(" ")'>
        <@service.NETWORK 'minio-net' />
        <@service.DC dc />
        <@service.ENV 'MINIO_ACCESS_KEY' '12345678' />
        <@service.ENV 'MINIO_SECRET_KEY' '12345678' />
      </@swarm.SERVICE>
    </#list>
  </@node.DATACENTER>
</@bash.PROFILE>