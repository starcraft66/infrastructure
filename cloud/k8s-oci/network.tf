# Virtual Network

module "vcn" {
  source = "git::https://github.com/starcraft66/terraform-oci-vcn.git?ref=main"

  compartment_id = var.compartment_id
  tenancy_id     = var.tenancy_id
  region         = var.region

  # VCN parameters
  vcn_name       = "k8s-vcn"
  vcn_dns_label  = "k8svcn"
  vcn_cidrs_ipv4 = ["10.233.192.0/18"]

  # IPv6 - enable dual-stack with Oracle GUA allocation
  enable_ipv6                          = true
  vcn_is_oracle_gua_allocation_enabled = true

  # Gateways
  create_internet_gateway      = true
  create_nat_gateway           = true
  create_service_gateway       = true
  internet_gateway_route_rules = null
  nat_gateway_route_rules      = null
  local_peering_gateways       = null
}

# Subnets
# Dual-stack OKE requires ALL subnets to be public:
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/conteng_ipv4-and-ipv6.htm

resource "oci_core_subnet" "vcn_worker_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.233.192.0/24"
  route_table_id = module.vcn.ig_route_id
  security_list_ids = [
    oci_core_security_list.worker_subnet_sl.id,
    oci_core_security_list.nlb_worker_subnet_sl.id
  ]
  display_name = "k8s-worker-subnet"

  # IPv6: first /64 from the VCN's Oracle GUA /56
  ipv6cidr_blocks = [cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 0)]
}

resource "oci_core_subnet" "vcn_public_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = module.vcn.vcn_id
  cidr_block        = "10.233.193.0/24"
  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.public_subnet_sl.id]
  display_name      = "k8s-public-subnet"

  # IPv6: second /64 from the VCN's Oracle GUA /56
  ipv6cidr_blocks = [cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 1)]
}

resource "oci_core_subnet" "vcn_pod_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.233.194.0/24"
  route_table_id = module.vcn.ig_route_id
  security_list_ids = [
    oci_core_security_list.pod_subnet_sl.id
  ]
  display_name = "k8s-pod-subnet"

  # IPv6: third /64 from the VCN's Oracle GUA /56
  ipv6cidr_blocks = [cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 2)]
}

# Security Lists

# Worker node subnet security list
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfig.htm
resource "oci_core_security_list" "worker_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "k8s-worker-subnet-sl"

  # Egress: allow all IPv4
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # Egress: allow all IPv6
  egress_security_rules {
    stateless        = false
    destination      = "::/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # Ingress: worker-to-worker (IPv4)
  ingress_security_rules {
    stateless   = false
    source      = "10.233.192.0/24"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: worker-to-worker (IPv6)
  ingress_security_rules {
    stateless   = false
    source      = cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 0)
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: pods to workers (IPv4)
  ingress_security_rules {
    stateless   = false
    source      = "10.233.194.0/24"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: pods to workers (IPv6)
  ingress_security_rules {
    stateless   = false
    source      = cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 2)
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: K8s API endpoint to workers (IPv4)
  ingress_security_rules {
    stateless   = false
    source      = "10.233.193.0/24"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: K8s API endpoint to workers (IPv6)
  ingress_security_rules {
    stateless   = false
    source      = cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 1)
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: ICMP path discovery
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
      code = 4
    }
  }
}

# K8s API endpoint / LB public subnet security list
resource "oci_core_security_list" "public_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "k8s-public-subnet-sl"

  # Egress: allow all IPv4
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # Egress: allow all IPv6
  egress_security_rules {
    stateless        = false
    destination      = "::/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # Ingress: from worker nodes (IPv4)
  ingress_security_rules {
    stateless   = false
    source      = "10.233.192.0/24"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: from worker nodes (IPv6)
  ingress_security_rules {
    stateless   = false
    source      = cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 0)
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: from pods (IPv4)
  ingress_security_rules {
    stateless   = false
    source      = "10.233.194.0/24"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: from pods (IPv6)
  ingress_security_rules {
    stateless   = false
    source      = cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 2)
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: K8s API from internet (IPv4)
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # Ingress: K8s API from internet (IPv6)
  ingress_security_rules {
    stateless   = false
    source      = "::/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 6443
      max = 6443
    }
  }
}

# Pod subnet security list (VCN-Native pod networking)
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfig.htm#securitylistconfig__section_rules_for_pod_subnets
resource "oci_core_security_list" "pod_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "k8s-pod-subnet-sl"

  # Egress: allow all IPv4
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # Egress: allow all IPv6
  egress_security_rules {
    stateless        = false
    destination      = "::/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # Ingress: K8s API endpoint to pods (IPv4)
  ingress_security_rules {
    stateless   = false
    source      = "10.233.193.0/24"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: K8s API endpoint to pods (IPv6)
  ingress_security_rules {
    stateless   = false
    source      = cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 1)
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: worker nodes to pods (IPv4)
  ingress_security_rules {
    stateless   = false
    source      = "10.233.192.0/24"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: worker nodes to pods (IPv6)
  ingress_security_rules {
    stateless   = false
    source      = cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 0)
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: pod-to-pod (IPv4)
  ingress_security_rules {
    stateless   = false
    source      = "10.233.194.0/24"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Ingress: pod-to-pod (IPv6)
  ingress_security_rules {
    stateless   = false
    source      = cidrsubnet(module.vcn.vcn_ipv6cidr_blocks[0], 8, 2)
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }
}

# For network load balancer
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingnetworkloadbalancers.htm
resource "oci_core_security_list" "nlb_worker_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "nlb-k8s-worker-subnet-sl"

  # IPv4 NodePort range
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 30000
      max = 32767
    }
  }

  # IPv6 NodePort range
  ingress_security_rules {
    stateless   = false
    source      = "::/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 30000
      max = 32767
    }
  }
}
