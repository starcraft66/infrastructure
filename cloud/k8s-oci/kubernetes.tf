resource "oci_containerengine_cluster" "k8s_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "k8s-cluster"
  vcn_id             = module.vcn.vcn_id
  type               = "BASIC_CLUSTER"
  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.vcn_public_subnet.id
  }
  options {
    ip_families = ["IPv4", "IPv6"]
    kubernetes_network_config {
      # OKE auto-appends IPv6 ULA CIDRs for dual-stack clusters
      pods_cidr     = "10.244.0.0/16,fd00:eeee:eeee:0000::/96"
      services_cidr = "10.96.0.0/16,fd00:eeee:eeee:0001::/108"
    }
    service_lb_subnet_ids = [oci_core_subnet.vcn_public_subnet.id]
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_containerengine_node_pool_option" "node_pool_options" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_id
}

locals {
  # Strip leading "v" from kubernetes_version for image name matching (images use "OKE-1.34.2" not "OKE-v1.34.2")
  k8s_version_bare = trimprefix(var.kubernetes_version, "v")

  # Find the latest OKE-optimized Oracle Linux 8 aarch64 image matching our k8s version
  oke_images = [
    for s in data.oci_containerengine_node_pool_option.node_pool_options.sources :
    s if(
      length(regexall("Oracle-Linux-8", s.source_name)) > 0 &&
      length(regexall("aarch64", s.source_name)) > 0 &&
      length(regexall(local.k8s_version_bare, s.source_name)) > 0
    )
  ]
  node_image_id = local.oke_images[0].image_id
}

resource "oci_containerengine_node_pool" "k8s_node_pool" {
  cluster_id         = oci_containerengine_cluster.k8s_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "k8s-node-pool"

  # node_metadata = {
  #   user_data = base64encode(file("files/node-pool-init.sh"))
  # }

  node_config_details {
    dynamic "placement_configs" {
      for_each = data.oci_identity_availability_domains.ads.availability_domains
      content {
        availability_domain = placement_configs.value.name
        subnet_id           = oci_core_subnet.vcn_worker_subnet.id
      }
    }

    size = var.kubernetes_worker_nodes
  }

  node_shape = "VM.Standard.A1.Flex"

  node_shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }
  node_source_details {
    source_type             = "IMAGE"
    image_id                = local.node_image_id
    boot_volume_size_in_gbs = 100
  }
  initial_node_labels {
    key   = "name"
    value = "k8s-cluster"
  }

  ssh_public_key = var.ssh_public_key
}