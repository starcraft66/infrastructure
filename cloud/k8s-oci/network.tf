# Virtual Network

module "vcn" {
  source = "../../../terraform-oci-vcn"

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

resource "oci_core_subnet" "vcn_worker_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.233.192.0/24"

  # IGW route table: dual-stack OKE requires public subnets for workers
  # IGW handles both IPv4 and IPv6 default routes
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

# Security Lists

resource "oci_core_security_list" "worker_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "k8s-worker-subnet-sl"

  # IPv4 egress everywhere
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # IPv6 egress everywhere
  egress_security_rules {
    stateless        = false
    destination      = "::/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # IPv4 ingress from VCN CIDR
  ingress_security_rules {
    stateless   = false
    source      = "10.233.192.0/18"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # IPv6 ingress from VCN IPv6 CIDR
  ingress_security_rules {
    stateless   = false
    source      = module.vcn.vcn_ipv6cidr_blocks[0]
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }
}

resource "oci_core_security_list" "public_subnet_sl" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "k8s-public-subnet-sl"

  # IPv4 egress everywhere
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # IPv6 egress everywhere
  egress_security_rules {
    stateless        = false
    destination      = "::/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # IPv4 ingress from VCN CIDR
  ingress_security_rules {
    stateless   = false
    source      = "10.233.192.0/18"
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # IPv6 ingress from VCN IPv6 CIDR
  ingress_security_rules {
    stateless   = false
    source      = module.vcn.vcn_ipv6cidr_blocks[0]
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # IPv4 ingress K8s API from internet
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

  # IPv6 ingress K8s API from internet
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
