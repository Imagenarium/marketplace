<@requirement.PARAM 'RECEIVER_HOST' />
<@requirement.PARAM 'RECEIVER_PORT' '8080' />
<@requirement.PARAM 'BROKER_NETWORK' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'invoice-sender-${uniqueId}' 'man4j/invoice-sender:latest'>
    <@service.NETWORK PARAMS.BROKER_NETWORK />
    <@service.ENV 'RECEIVER_HOST' PARAMS.RECEIVER_HOST />
    <@service.ENV 'RECEIVER_PORT' PARAMS.RECEIVER_PORT />
  </@swarm.SERVICE>
</@requirement.CONFORMS>
