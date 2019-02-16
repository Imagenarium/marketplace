<#list 1..3 as index>
  <@img.REMOVE 'redis-sentinel-${index}-${namespace}' />
</#list>

<#list 1..3 as index>
  <@img.REMOVE 'redis-${index}-${namespace}' />
</#list>


<@img.REMOVE 'net-${namespace}' />
