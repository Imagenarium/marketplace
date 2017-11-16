<@requirement.PARAM 'BROKER_LIST' />
<@requirement.PARAM 'BROKER_NETWORK' />
<@requirement.PARAM 'AUTO_OFFSET_RESET' 'latest' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'invoice-processor-${uniqueId}' 'man4j/invoice-processor:0.1'>
      <@service.NETWORK PARAMS.BROKER_NETWORK />
      <@service.ENV 'brokerList' PARAMS.BROKER_LIST />
      <@service.ENV 'autoOffsetReset' PARAMS.AUTO_OFFSET_RESET />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
