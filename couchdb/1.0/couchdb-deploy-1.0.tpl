<@bash.HEADER />

<@bash.PROFILE>

  <@docker.CONTAINER 'zookeeper-checker' 'imagenarium/zookeeper-checker:1.0'>
    <@container.INTERACTIVELY />
    <@container.EPHEMERAL />
  </@docker.CONTAINER>
    
</@bash.PROFILE>