<@img.REMOVE 'es-checker-${namespace}' />

<#list "1,2,3"?split(",") as index>
  <@img.REMOVE 'es-master-${index}-${namespace}' />
</#list>

<@img.REMOVE 'es-router-${namespace}' />
  
<@img.REMOVE 'es-net-${namespace}' />