# Install Loki Stack

Create a namespace

```sh
kubectl create ns loki
```

add helm repository

```sh
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

Install the loki Stack

```sh
kubens loki

helm upgrade --install loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false,prometheus-node-exporter.hostRootFsMount.enabled=false,loki.persistence.enabled=true,loki.persistence.storageClassName=nfs-storage,loki.persistence.size=5Gi
```

Create an ingress controller for grafana

```sh
kubectl create ingress grafana --class=nginx \
  --rule="grafana.example.com/*=loki-grafanao:80"
```
