<@requirement.CONFORMS>
  <#assign brokerList = [] />

  <#list 1..3 as index>
    <#assign brokerList += ['kafka-${index}-${namespace}:9092'] />
  </#list>

  <@swarm.SERVICE 'invoice-sender-${namespace}' 'man4j/invoice-sender:0.1'>
    <@service.NETWORK 'kafka-net-${namespace}' />
    <@service.ENV 'brokerList' brokerList?join(",") />
  </@swarm.SERVICE>
  
  <@docker.HTTP_CHECKER 'sender-checker-${namespace}' 'http://invoice-sender-${namespace}:8080' 'kafka-net-${namespace}' />
</@requirement.CONFORMS>
