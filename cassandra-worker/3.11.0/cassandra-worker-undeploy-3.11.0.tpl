<@requirement.PARAM 'dc' />
<@requirement.PARAM 'workerId' />

<@swarm.SERVICE_RM 'cassandra-worker-${params.dc}-${params.workerId}' />