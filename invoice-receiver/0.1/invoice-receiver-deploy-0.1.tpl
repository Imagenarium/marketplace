<@requirement.PARAM name='PUBLISHED_PORT' value='-1' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'invoice-receiver-${dc}-${namespace}' 'man4j/invoice-receiver:0.1'>
      <@service.NETWORK 'kafka-net-${namespace}' />
      <@service.DC dc />
      <@service.PORT PARAMS.PUBLISHED_PORT '8080' 'host' />
      <@service.ENV 'brokerList' 'kafka-${dc}-${namespace}:9092' />
    </@swarm.SERVICE>
  
    <@docker.HTTP_CHECK 'http://invoice-receiver-${dc}-${namespace}:8080' 'kafka-net-${namespace}' />
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
