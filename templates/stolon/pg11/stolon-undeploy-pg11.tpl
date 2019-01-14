<@img.REMOVE 'stolon-proxy-${namespace}' />

<#list 1..3 as index>
  <@img.REMOVE 'stolon-sentinel-${index}-${namespace}' />
</#list>

<#list 1..2 as index>
  <@img.REMOVE 'stolon-keeper-${index}-${namespace}' />
</#list>

<@img.REMOVE 'net-${namespace}' />
