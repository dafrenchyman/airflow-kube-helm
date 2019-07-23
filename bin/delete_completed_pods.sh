#!/bin/bash

export PODS_TO_DELETE=`kubectl get pods | grep -e Completed -e Error -e ImagePullBackOff | awk '{print $1}'`
kubectl delete pods ${PODS_TO_DELETE}
