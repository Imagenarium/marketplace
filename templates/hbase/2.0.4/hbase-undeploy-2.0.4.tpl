<#list 1..3 as index>
  <@img.REMOVE 'hbase-region-${index}-${namespace}' />
  <@img.REMOVE 'hbase-master-${index}-${namespace}' />
</#list>
 
<@img.REMOVE 'net-${namespace}' />
