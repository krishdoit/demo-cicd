#!/bin/bash
set -e
mkdir -p $HOME/.kube
cd ../
terraform output kubeconfig > $HOME/.kube/config
chmod 600 $HOME/.kube/config
sed -i "/\bEOT\b/d" $HOME/.kube/config
mkdir -p $HOME/config-map
terraform output config-map-aws-auth > $HOME/config-map/config-map.yml
sed -i "/\bEOT\b/d" $HOME/config-map/config-map.yml

kubectl create -f $HOME/config-map/config-map.yml

sleep 120;

helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install servian-challenge nginx-stable/nginx-ingress
kubectl scale deploy/servian-challenge-nginx-ingress --replicas=3
