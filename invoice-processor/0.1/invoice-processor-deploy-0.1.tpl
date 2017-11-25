<@requirement.PARAM 'uniqueId' />
<@requirement.PARAM 'AUTO_OFFSET_RESET' 'latest' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'invoice-processor-${dc}-${uniqueId}' 'man4j/invoice-processor:0.1'>
      <@service.NETWORK 'kafka-net-${uniqueId}' />
      <@service.ENV 'brokerList' 'kafka-${dc}-${uniqueId}:9092' />
      <@service.ENV 'autoOffsetReset' PARAMS.AUTO_OFFSET_RESET />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
