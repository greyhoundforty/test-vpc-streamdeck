locals {
    prefix = random_string.prefix.result
  region_zones = length(data.ibm_is_zones.regional.zones)
  vpc_zones = {
    for zone in range(local.region_zones) : zone => {
      zone = "${var.region}-${zone + 1}"
    }
  }

  deploy_timestamp = formatdate("YYYYMMDD-HHmm", time_static.deploy_time.rfc3339)

  tags = [
    "created_at:${local.deploy_timestamp}",
    "region:${var.region}",
  ]
}


resource "time_static" "deploy_time" {
  # Leave triggers empty to prevent the timestamp from changing
  triggers = {}
}

resource "random_string" "prefix" {
  length  = 4
  special = false
  numeric = false
  upper   = false
}

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.5"
  resource_group_name          = var.existing_resource_group == null ? "${local.prefix}-resource-group" : null
  existing_resource_group_name = var.existing_resource_group
}

resource "ibm_is_vpc" "lab" {
  name                        = "${local.prefix}-vpc"
  resource_group              = module.resource_group.resource_group_id
  address_prefix_management   = var.default_address_prefix
  default_network_acl_name    = "${local.prefix}-default-vpc-nacl"
  default_security_group_name = "${local.prefix}-default-vpc-sg"
  default_routing_table_name  = "${local.prefix}-default-vpc-rt"
  tags                        = local.tags

  lifecycle {
    ignore_changes = [tags]
  }
}