#!/bin/bash
RESOLVER_DIR=/etc/resolver
CLUSTER_1_DOMAINS=('svc.cluster.local')

CLUSTER_1_NS='100.76.0.10' # IP of kube-dns service

#Make resolver directory
[ -d $RESOLVER_DIR ] || mkdir $RESOLVER_DIR
cd $RESOLVER_DIR

for DOMAIN in "${CLUSTER_1_DOMAINS[@]}"; do
    touch $DOMAIN
    echo "domain $DOMAIN
nameserver $CLUSTER_1_NS" >$DOMAIN
done
