variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "ssh_public_key" {
  type        = string
  description = "Path to ssh public key for instances"
}

variable "network" {
  type = object({
    cidr_block_vpc = string
    subnets        = list(map(any))
  })

  default = {
    cidr_block_vpc = "10.100.0.0/16"
    subnets = [
      {
        az         = "eu-west-1a"
        cidr_block = "10.100.10.0/24"
      },
      {
        az         = "eu-west-1b"
        cidr_block = "10.100.20.0/24"
      }
    ]
  }
}

variable "webserver_instance" {
  type = object({
    names = list(string)
    ami   = string
    type  = string
  })

  default = {
    names = ["webserver-A", "webserver-B"]
    ami   = "ami-005e7be1c849abba7"
    type  = "t2.micro"
  }
}

variable "health_check" {
  type = map(any)
  default = {
    "timeout"           = 10
    "interval"          = 20
    "path"              = "/"
    "port"              = 80
    unhealthy_threshold = 2
    healthy_threshold   = 3
  }
}
