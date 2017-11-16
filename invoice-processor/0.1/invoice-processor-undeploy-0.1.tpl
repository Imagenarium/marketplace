<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'invoice-processor-${uniqueId}' />
  </@cloud.DATACENTER>
</@requirement.CONFORMS>
