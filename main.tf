provider "aws" {
    default_tags {
        tags = {
            purpose = "esgi-group-7"
        }
    }

    region = var.AWS_REGION
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
}

resource "aws_key_pair" "deployer-key-lgr" {
  key_name   = "key-pair-lgr"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAqcAT5IyVi+055RqiC+KZ/5+zKArowoqzf76p4RE2TCGVVS3fwp8A1RITPrKHJyQLUYZHJIb1PCAUxLQQ2y8YwbvNaepkJIaSUozIp/lctd0ZHApq2p2SW/4bbOoMVAYl5w+1qerjaaks/EaQO5T6t7aDVA6FW9GYdia/2wsP9FukGoG5cCOu+DbBbpTjGrJGOZULDleGhd+C8WGLEOQCnP9w+Qb+GHMNVtLRiBNeKj3zroit23ft0Ezxed7acCCFbzWGqCYklQlnhbeXlGT4EVwAdRSGnI+HOECRzFgjuRaxB0xcj6hDPQBVdlDT6b5x+eKUq4KOzgO8J30kjvCwZy64v00QgeVvn3p6MH43SSwozbt1p7sE40419k4jL6OT7V0nhjhXs3ycriWRZQWQfJq0T8pWPlXXhOgZmPg3R6fdseaweigjFwlMphGs2/iyx8Zl5P5pA2n/3q0aJ0wBmP/aJFNZY/dHWLvbeI5t7RtBP/RGA6n3idM+i7I9TM0= louis-guilhem@LUIGI"
}

resource "aws_instance" "webserver" {
    count         = length(var.instance_names)
    ami           = "ami-005e7be1c849abba7"
    instance_type = var.instance_type

    user_data = <<-EOF
        #!/bin/bash
        sudo su
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd  
        echo "Response coming from server ${var.instance_names[count.index]}" > /var/www/html/index.htm
    EOF
    tags = {
        Name = var.instance_names[count.index]
    }
 }


resource "aws_security_group" "instance_sg" {
    name = "terraform-test-sg"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = var.INGRESS_PORT_HTTP
        to_port     = var.INGRESS_PORT_HTTP
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "public_ips" {
  value = {
    for name, instance in aws_instance.webserver : name => instance.public_ip
  }
}


resource "aws_lb_target_group" "web_server_tg" {
  name       = "web-server-TG"
  port       = 80
  protocol   = "HTTP"

  health_check {
    enabled             = true
    port                = 80
    interval            = 5
    protocol            = "HTTP"
    path                = "/index.html"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  for_each = aws_instance.webserver

  target_group_arn = aws_lb_target_group.web_server_tg.arn
  target_id        = each.value.id
  port             = 80
}

resource "aws_lb" "web_server_lb" {
  name               = "Web-server-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.instance_sg.id]

}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_server_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_tg.arn
  }
}