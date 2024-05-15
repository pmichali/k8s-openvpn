#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: $0 <CLIENT_KEY_NAME>"
  exit
fi

KEY_NAME=$1
NAMESPACE=k8s-openvpn
HELM_RELEASE=openvpn
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" -- /etc/openvpn/setup/revokeClientCert.sh $KEY_NAME
