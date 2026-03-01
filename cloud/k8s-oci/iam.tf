# IAM policies required for OKE dual-stack IPv6 + VCN-Native pod networking
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/conteng_ipv4-and-ipv6.htm
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengpodnetworking_topic-OCI_CNI_plugin.htm

resource "oci_identity_policy" "ipv6_policy" {
  compartment_id = var.tenancy_id
  name           = "k8s-oke-policy"
  description    = "Allow OKE cluster to use IPv6 addresses and manage VCN-Native pod networking"
  statements = [
    "Allow any-user to use ipv6s in tenancy where all { request.principal.id = '${oci_containerengine_cluster.k8s_cluster.id}' }",
    "Allow any-user to manage instances in tenancy where all { request.principal.id = '${oci_containerengine_cluster.k8s_cluster.id}' }",
    "Allow any-user to use private-ips in tenancy where all { request.principal.id = '${oci_containerengine_cluster.k8s_cluster.id}' }",
    "Allow any-user to use network-security-groups in tenancy where all { request.principal.id = '${oci_containerengine_cluster.k8s_cluster.id}' }",
  ]
}
