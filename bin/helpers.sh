#!/usr/bin/env bash

# Get Airflow web pod to set variables
export AIRFLOW_EXEC_POD=`kubectl --namespace ${NAMESPACE} get pods | grep airflow-web -m 1| cut -f1 -d' '`

# Add variable (key, value) pairs to Airflow
add_variables () {
    _NAMESPACE=$1
    _KEY=$2
    _VALUE=$3
    kubectl --namespace ${_NAMESPACE} exec ${AIRFLOW_EXEC_POD} -c webserver -- \
        sh -c "/entrypoint.sh airflow variables --set ${_KEY} ${_VALUE}"
}

# Add connections to Airflow
add_connection () {
    _NAMESPACE=$1
    _CONN_ID=$2
    _CONN_TYPE=$3
    _CONN_PASSWORD=$3

    kubectl --namespace ${_NAMESPACE} exec ${AIRFLOW_EXEC_POD} -c webserver -- \
        sh -c "/entrypoint.sh airflow connections --add \
        --conn_id ${_CONN_ID} \
        --conn_type ${_CONN_TYPE} \
        --conn_password ${_CONN_PASSWORD}"
}