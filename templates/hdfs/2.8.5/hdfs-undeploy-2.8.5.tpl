<#list 1..3 as index>
  <@img.REMOVE 'hdfs-data-${index}-${namespace}' />
</#list>

<#list 1..2 as index>
  <@img.REMOVE 'hdfs-name-${index}-${namespace}' />
</#list>

<#list 1..3 as index>
  <@img.REMOVE 'hdfs-journal-${index}-${namespace}' />
</#list>
 
<@img.REMOVE 'net-${namespace}' />
