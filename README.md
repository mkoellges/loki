# Install Loki Stack

This cookbook installs a loki stack in a kubernetes created by docker for desktop.

## Create a namespace

```sh
kubectl create ns loki

kubens loki

helm upgrade --install loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=true,lok-prometheus-node-exporter.hostRootFsMount.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=hostpath,loki.persistence.size=5Gi

kubectl patch ds loki-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'

kubectl port-forward --namespace loki service/loki-grafana 3000:80
```

## Get the grafana admin password

```sh
kubectl get secret --namespace loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## open Grafana

```sh
open http://localhost:3000
```
