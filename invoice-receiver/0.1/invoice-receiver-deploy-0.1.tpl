<@requirement.PARAM 'uniqueId' />
<@requirement.PARAM 'PUBLISHED_PORT' '-1' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'invoice-receiver-${dc}-${uniqueId}' 'man4j/invoice-receiver:0.1'>
      <@service.NETWORK 'kafka-net-${uniqueId}' />
      <@service.PORT PARAMS.PUBLISHED_PORT '8080' 'host' />
      <@service.ENV 'brokerList' 'kafka-${dc}-${uniqueId}:9092' />
    </@swarm.SERVICE>
  
    <@docker.HTTP_CHECK 'http://invoice-receiver-${dc}-${uniqueId}:8080' 'kafka-net-${uniqueId}' />
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
