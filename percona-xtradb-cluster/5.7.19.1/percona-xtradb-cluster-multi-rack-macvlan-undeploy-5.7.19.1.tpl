<@requirement.CONFORMS>
  <@swarm.SERVICE_RM 'percona-init-${namespace}' />

  <#list "rack1,rack2,rack3"?split(",") as rack>
    <@swarm.SERVICE_RM 'percona-master-${rack}-${namespace}' />
  </#list>
</@requirement.CONFORMS>
