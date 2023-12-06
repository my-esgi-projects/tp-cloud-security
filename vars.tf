variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
    type = string
    default = "eu-west-1"
    description = "region de notre instance"
}

variable "instance_type" {

    type = string
    default = "t2.micro"
    description = "EC2 instance type"

}

variable "INGRESS_PORT_HTTP" {
    type = number
    default = 80
}

variable "instance_names" {
  type    = list
  default = ["webserver-A", "webserver-B"]
}