<@requirement.PARAM name='AUTO_OFFSET_RESET' value='earliest' type='select' values='latest,earliest' />

<@requirement.CONFORMS>
  <#assign brokerList = [] />

  <#list 1..3 as index>
    <#assign brokerList += ['kafka-${index}-${namespace}:9092'] />
  </#list>

  <@swarm.SERVICE 'invoice-processor-${namespace}' 'man4j/invoice-processor:0.2'>
    <@service.SCALABLE />
    <@service.NETWORK 'kafka-net-${namespace}' />
    <@service.ENV 'brokerList' brokerList?join(",") />
    <@service.ENV 'autoOffsetReset' PARAMS.AUTO_OFFSET_RESET />
  </@swarm.SERVICE>

  <@docker.HTTP_CHECKER 'processor-checker-${namespace}' 'http://invoice-processor-${namespace}:8080' 'kafka-net-${namespace}' />
</@requirement.CONFORMS>
