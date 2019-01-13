<@img.REMOVE 'etcd-checker-${namespace}' />

<#list 1..3 as index>
  <@img.REMOVE 'etcd-${index}-${namespace}' />
</#list>
  
<@img.REMOVE 'net-${namespace}' />
