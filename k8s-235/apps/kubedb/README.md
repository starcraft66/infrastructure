# KubeDB Installation

Unfortunately, I can't for the life of me get KubeDB to install via Kustomize, there's an issue regarding the TLS certificates created making kube-apiserver unable to talk to the KubeDB operator via certain webhooks. Unfortunately Helm will need to be used to install KubeDB.

Run:
```
kubectl create ns kubedb
helm install kubedb-community appscode/kubedb \
  --set monitoring.enabled=true \
  --set monitoring.agent="prometheus.io/operator" \
  --set monitoring.serviceMonitor.labels."app\.kubernetes\.io/name"=kubedb \
  --version v0.16.2 \
  --namespace kubedb \
  --set-file license=
helm install kubedb-catalog appscode/kubedb-catalog --version v0.16.2 --namespace kubedb
```