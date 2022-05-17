#!/bin/bash
kubectl create ns grafana-loki

helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

kubens grafana-loki

helm upgrade --install loki --namespace=grafana-loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=true,prometheus.server.persistentVolume.enabled=true

kubectl create ingress grafana --class=nginx \
  --rule="grafana.example.com/*=loki-grafanao:80"

# alternativ: 
# kubectl port-forward --namespace loki service/loki-grafana 3000:80

kubectl get secret --namespace loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo