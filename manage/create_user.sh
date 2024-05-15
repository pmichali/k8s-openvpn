#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 2 ]
then
  echo "Usage: $0 <CLIENT_KEY_NAME> [<DOMAIN_NAME>]"
  exit
fi

KEY_NAME=$1
NAMESPACE=k8s-openvpn
HELM_RELEASE=openvpn
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')
if [ -n "$2" ]
then
    SERVICE_IP=$2
else
    SERVICE_NAME=$(kubectl get svc -n "$NAMESPACE" -l "app=openvpn,release=$HELM_RELEASE" -o jsonpath='{.items[0].metadata.name}')
    SERVICE_IP=$(kubectl get svc -n "$NAMESPACE" "$SERVICE_NAME" -o go-template='{{range $k, $v := (index .status.loadBalancer.ingress 0)}}{{$v}}{{end}}')
fi
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" -c openvpn -- /etc/openvpn/setup/newClientCert.sh "$KEY_NAME" "$SERVICE_IP"
kubectl -n "$NAMESPACE" exec -it "$POD_NAME" -c openvpn -- cat "/etc/openvpn/pki/$KEY_NAME.ovpn" > "$KEY_NAME.ovpn"
