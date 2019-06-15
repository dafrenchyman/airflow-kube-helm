#!/bin/bash

NAMESPACE=default
SHA=97cb6b43f95bd7c0805a143f37ab89863844ca27

# Get Airflow web pod to set variables
export AIRFLOW_POD=`kubectl --namespace ${NAMESPACE} get pods | grep airflow-web -m 1| cut -f1 -d' '`

# Source env we will need
source airflow_vars.env

add_variables () {
    KEY=$1
    VALUE=$2
    kubectl --namespace ${NAMESPACE} exec ${AIRFLOW_POD} -c webserver -- sh -c "/entrypoint.sh airflow variables --set ${KEY} ${VALUE}"
}

######################################
# Add variables to airflow
######################################

# Overall
add_variables kube_namespace default

# Amount
add_variables invoice_processing_amount_counter 0
add_variables invoice_processing_amount_sha ${SHA}
add_variables invoice_processing_amount_max_obs_to_save 900
add_variables invoice_processing_amount_vhosts "[\\\"allied\\\"]"

# Coldstart
add_variables invoice_processing_coldstart_counter 0
add_variables invoice_processing_coldstart_sha ${SHA}
add_variables invoice_processing_coldstart_vhosts "[\\\"allied\\\"]"

# Experiments
add_variables invoice_processing_experiments_always_train	True
add_variables invoice_processing_experiments_counter	0
add_variables invoice_processing_experiments_sha    ${SHA}
add_variables invoice_processing_experiments_vhosts "[\\\"allied\\\"]"

# Tester
add_variables invoice_processing_experiments_tester_always_train	True
add_variables invoice_processing_experiments_tester_counter	0
add_variables invoice_processing_experiments_tester_sha    ${SHA}
add_variables invoice_processing_experiments_tester_vhosts "[\\\"allied\\\"]"

# Manual
add_variables invoice_processing_manual_always_train	True
add_variables invoice_processing_manual_counter	0
add_variables invoice_processing_manual_sha	${SHA}
add_variables invoice_processing_manual_vhosts	"[\\\"allied\\\"]"

# reference
add_variables invoice_processing_reference_counter	0
add_variables invoice_processing_reference_sha	${SHA}
add_variables invoice_processing_reference_vhosts "[\\\"allied\\\"]"

######################################
# Add connections to airflow
######################################

# Insert slack oauth
kubectl --namespace ${NAMESPACE} exec ${AIRFLOW_POD} -c webserver -- sh -c "/entrypoint.sh airflow connections --add --conn_id slack_connection_airflow --conn_type http --conn_password ${SLACK_OAUTH}"

