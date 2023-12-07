resource "aws_lb_target_group" "target_group" {
  name        = "${local.resource_prefix}-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    enabled             = true
    healthy_threshold   = var.health_check.healthy_threshold
    interval            = var.health_check.interval
    unhealthy_threshold = var.health_check.unhealthy_threshold
    timeout             = var.health_check.timeout
    path                = var.health_check.path
    port                = var.health_check.port
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count            = length(var.webserver_instance.names)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.webserver_instance[count.index].id
  port             = 80
}
