# Loki

## 1. docker-compose

```sh
mkdir ./volumes/grafana
mkdir ./volumes/loki
mkdir ./volumes/promtail

docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
```

Now add the following config to your docker-deamen config

```json
  "log-driver": "loki",
  "log-opts": {
     "loki-url": "http://localhost:3100/loki/api/v1/push",
     "loki-batch-size": "400"
  }
```

Now run the docker stack

```sh
echo "docker-compose up -d --force-recreate"
```

## 2. Kubernetes

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

kubectl create ns grafana-loki

helm upgrade --install loki --namespace=grafana-loki grafana/loki-stack --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=true,prometheus.server.persistentVolume.enabled=true,prometheus-node-exporter.hostRootFsMount.enabled=false

kubectl patch ds loki-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'

kubectl get secret -n grafana-loki loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

kubectl port-forward -n grafana-loki deployment/loki-grafana 3000
```
