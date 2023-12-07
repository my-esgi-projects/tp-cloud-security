provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    tags = {
      purpose        = "${local.organization}-group-${local.group}"
      resource-owner = local.resource_prefix
    }
  }
}
