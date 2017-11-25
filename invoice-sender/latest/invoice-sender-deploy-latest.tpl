<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@swarm.SERVICE 'invoice-sender-${uniqueId}' 'man4j/invoice-sender:latest'>
    <@service.NETWORK 'kafka-net-${uniqueId}' />
    <@service.ENV 'RECEIVER_HOST' 'invoice-receiver-dc1-${uniqueId}' />
    <@service.ENV 'RECEIVER_PORT' '8080' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>
