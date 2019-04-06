<@img.REMOVE 'zookeeper-checker-${namespace}' />

<#list 1..3 as index>
  <@img.REMOVE 'zookeeper-${index}-${namespace}' />
</#list>

<@img.REMOVE 'zookeeper-exporter-${namespace}' />

<@img.REMOVE 'net-${namespace}' />
