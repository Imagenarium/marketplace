<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'invoice-receiver-${dc}-${uniqueId}' />
  </@cloud.DATACENTER>

  set +e
  <@swarm.NETWORK_RM 'kafka-net-${uniqueId}' />
</@requirement.CONFORMS>
