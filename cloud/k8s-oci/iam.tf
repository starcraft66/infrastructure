# IAM policy required for OKE dual-stack IPv6 support
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/conteng_ipv4-and-ipv6.htm

resource "oci_identity_policy" "ipv6_policy" {
  compartment_id = var.tenancy_id
  name           = "k8s-ipv6-policy"
  description    = "Allow OKE cluster to use IPv6 addresses on VNICs"
  statements = [
    "Allow any-user to use ipv6s in tenancy where all { request.principal.id = '${oci_containerengine_cluster.k8s_cluster.id}' }"
  ]
}
