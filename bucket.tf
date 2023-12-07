resource "aws_s3_bucket" "state_bucket" {
  bucket = "${local.resource_prefix}-state-bucket"
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_s3_bucket" "elb_log_bucket" {
  bucket = "${local.resource_prefix}-elb-log-bucket"
}
