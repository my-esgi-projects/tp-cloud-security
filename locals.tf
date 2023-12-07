locals {
  organization = "esgi"
  class        = "src-2"
  group        = "7"
}

locals {
  resource_prefix = "${local.organization}-${local.class}-group-${local.group}"
}

locals {
  sg_ports_allowed = {
    in          = [22, 80]
    out         = [0]
    cidr_blocks = ["0.0.0.0/0"]
  }
}
