# KubeDB Update

To update kubedb manifests run:
```
helm template kubedb-community appscode/kubedb \
  --set monitoring.enabled=true \
  --set monitoring.agent="prometheus.io/operator" \
  --set monitoring.serviceMonitor.labels."app\.kubernetes\.io/name"=kubedb \
  --version v2021.03.17 \
  --namespace kubedb \
  --set-file global.license=<path to license>
  --set global.skipCleaner=true > kubedb.yaml
```