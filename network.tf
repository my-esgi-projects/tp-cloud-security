resource "aws_vpc" "vpc" {
  cidr_block = var.network.cidr_block_vpc

  tags = {
    Name = "${local.resource_prefix}-vpc"
  }
}


resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.network.subnets)
  cidr_block        = var.network.subnets[count.index].cidr_block
  availability_zone = var.network.subnets[count.index].az

  tags = {
    Name = "${local.resource_prefix}-subnet-${var.webserver_instance.names[count.index]}"
  }

  depends_on = [
    aws_vpc.vpc,
  ]
}


resource "aws_security_group" "security_group" {
  name        = "${local.resource_prefix}-sg-allow-required-traffic"
  vpc_id      = aws_vpc.vpc.id
  description = "Allow required traffic: http and ssh are sufficients"

  dynamic "ingress" {
    for_each = toset(local.sg_ports_allowed.in)
    content {
      description = "Allow ingress traffic"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = local.sg_ports_allowed.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = toset(local.sg_ports_allowed.out)
    content {
      description = "Allow egress traffic"
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = local.sg_ports_allowed.cidr_blocks
    }
  }

  depends_on = [
    aws_vpc.vpc,
    aws_subnet.subnet,
  ]
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${local.resource_prefix}-internet-gateway"
  }

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${local.resource_prefix}-route-table"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table_association" "subnet_association" {
  count          = length(var.network.subnets)
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.route_table.id

  depends_on = [aws_route_table.route_table]
}
