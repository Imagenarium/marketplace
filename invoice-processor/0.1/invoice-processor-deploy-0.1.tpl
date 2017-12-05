<@requirement.PARAM 'AUTO_OFFSET_RESET' 'latest' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'invoice-processor-${dc}-${namespace}' 'man4j/invoice-processor:0.1'>
      <@service.NETWORK 'kafka-net-${namespace}' />
      <@service.DC dc />
      <@service.ENV 'brokerList' 'kafka-${dc}-${namespace}:9092' />
      <@service.ENV 'autoOffsetReset' PARAMS.AUTO_OFFSET_RESET />
    </@swarm.SERVICE>

    <@docker.HTTP_CHECK 'http://invoice-processor-${dc}-${namespace}:8080' 'kafka-net-${namespace}' />
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
