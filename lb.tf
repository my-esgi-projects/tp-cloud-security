resource "aws_lb" "lb" {
  name                             = "${local.resource_prefix}-lb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.security_group.id]
  subnets                          = aws_subnet.subnet.*.id
  enable_cross_zone_load_balancing = "true"

  access_logs {
    bucket  = aws_s3_bucket.elb_log_bucket.id
    prefix  = "elb-logs-webinstance"
    enabled = false
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
