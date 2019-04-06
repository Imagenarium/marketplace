<@img.REMOVE 'kafka-checker-${namespace}' />
  
<#list 1..3 as index>
  <@img.REMOVE 'kafka-${index}-${namespace}' />  
</#list>

<@img.REMOVE 'kafka-exporter-${namespace}' />

<@img.REMOVE 'net-${namespace}' />

