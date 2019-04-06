<@img.REMOVE 'cluster-checker-${namespace}' />

<#list 1..3 as index>
  <@img.REMOVE 'cockroachdb-${index}-${namespace}' />
  <@img.REMOVE 'nginx-cockroachdb-${index}-${namespace}' />
</#list>

<@img.REMOVE 'net-${namespace}' />