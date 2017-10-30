<@requirement.PARAM 'dc' />
<@requirement.PARAM 'workerId' />

<@swarm.SERVICE_RM 'cassandra-worker-${requirement.p.dc}-${requirement.p.workerId}' />