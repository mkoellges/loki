#!/bin/bash
kubectl create ns loki

helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

kubens loki

helm upgrade --install loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,prometheus-node-exporter.hostRootFsMount.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=hostpath,loki.persistence.size=5Gi

kubectl create ingress grafana --class=nginx \
  --rule="grafana.example.com/*=loki-grafanao:80"
