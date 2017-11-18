<@requirement.PARAM 'uniqueId' />

<@requirement.CONFORMS>
  <@cloud.DATACENTER ; dc, index, isLast>
    <@swarm.SERVICE_RM 'logstash-${dc}-${uniqueId}' />
  </@cloud.DATACENTER>
</@requirement.CONFORMS>