<@requirement.PARAM 'BROKER_LIST' />
<@requirement.PARAM 'BROKER_NETWORK' />
<@requirement.PARAM 'PUBLISHED_PORT' '-1' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE 'invoice-receiver-${uniqueId}' 'man4j/invoice-receiver-0.1' />
      <@service.NETWORK PARAMS.BROKER_NETWORK />
      <@service.PORT PARAMS.PUBLISHED_PORT '8080' />
      <@service.ENV 'brokerList' PARAMS.BROKER_LIST />
    </@swarm.SERVICE>
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
