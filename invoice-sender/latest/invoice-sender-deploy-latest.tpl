<@requirement.CONFORMS>
  <@swarm.SERVICE 'invoice-sender-${namespace}' 'man4j/invoice-sender:latest'>
    <@service.NETWORK 'kafka-net-${namespace}' />
    <@service.ENV 'RECEIVER_HOST' 'invoice-receiver-dc1-${namespace}' />
    <@service.ENV 'RECEIVER_PORT' '8080' />
  </@swarm.SERVICE>
</@requirement.CONFORMS>
