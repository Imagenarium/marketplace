<@requirement.HA />

<@requirement.CONFORMS>
  <@bash.PROFILE>  
    <@swarm.NETWORK 'zookeeper-net' />
  
    <#assign zoo_servers = [] />
    <#assign zoo_connect = [] />
  
    <@cloud.DATACENTER ; dc, index, isLast>
      <#assign zoo_servers += ['server.${index}=zookeeper-${dc}:2888:3888'] />
      <#assign zoo_connect += ['zookeeper-${dc}:2181'] />
    </@cloud.DATACENTER>

    <@swarm.SERVICE 'swarmstorage-zookeeper' 'imagenarium/swarmstorage:0.1'>
      <@service.NETWORK 'zookeeper-net' />
      <@node.MANAGER />
      <@service.DOCKER_SOCKET />
    </@swarm.SERVICE>
  
    <@cloud.DATACENTER ; dc, index, isLast>
      <@swarm.SERVICE 'zookeeper-${dc}' 'imagenarium/zookeeper:3.4.10'>
        <@service.NETWORK 'zookeeper-net' />
        <@service.DOCKER_SOCKET />
        <@service.DNSRR />
        <@service.DC dc />
        <@service.VOLUME 'zookeeper-data-volume' '/data' />
        <@service.VOLUME 'zookeeper-datalog-volume' '/datalog' />
        <@service.ENV 'SERVICE_NAME' 'zookeeper-${dc}' />
        <@service.ENV 'STORAGE_SERVICE' 'swarmstorage-zookeeper' />
        <@service.ENV 'ZOO_MY_ID' index />
        <@service.ENV 'JMXPORT' '9099' />
        <@service.ENV 'ZOO_SERVERS' zoo_servers?join(" ") />
      </@swarm.SERVICE>
    </@cloud.DATACENTER>
  
    <@docker.CONTAINER 'zookeeper-checker' 'imagenarium/zookeeper-checker:1.0'>
      <@container.NETWORK 'zookeeper-net' />
      <@container.EPHEMERAL />
      <@container.ENV 'ZOO_CONNECT' zoo_connect?join(",") />
    </@docker.CONTAINER>
  </@bash.PROFILE>
</@requirement.CONFORMS>