#!/bin/bash
kubectl create ns loki
kubens loki

helm upgrade --install loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,prometheus-node-exporter.hostRootFsMount.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=hostpath,loki.persistence.size=5Gi

kubectl port-forward --namespace loki service/loki-grafana 3000:80