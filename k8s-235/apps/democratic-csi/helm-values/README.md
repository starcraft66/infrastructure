# democratic-csi kustomize base generation

democratic-csi is distributed as a helm chart upstream. The kustomize base manifests can be generated from this chart using the yaml values files in this directory.

The resulting config file secrets must be placed in the sops encrypted secrets in `../overlays/prod/secrets` and removed from the generated manifests.

```
helm template --values freenas-iscsi.yaml --namespace democratic-csi zfs-iscsi democratic-csi/democratic-csi > ../base/iscsi.yaml
helm template --values freenas-nfs.yaml --namespace democratic-csi zfs-nfs democratic-csi/democratic-csi > ../base/nfs.yaml
```