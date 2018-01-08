<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'percona-init-${namespace}' />

  <#list "1,2,3"?split(",") as rack>
    <@swarm.SERVICE_RM 'percona-master-${rack}-${namespace}' />
  </#list>
</@requirement.CONFORMS>
