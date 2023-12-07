resource "aws_s3_bucket" "state_bucket" {
  bucket = "${local.resource_prefix}-state-bucket"
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_s3_bucket" "elb_log_bucket" {
  bucket        = "${local.resource_prefix}-elb-log-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "elb_log_bucket_policy" {
  bucket = aws_s3_bucket.elb_log_bucket.id

  policy = jsonencode({
    Id : "Policy1701932144715",
    Version : "2012-10-17",
    Statement : [
      {
        "Sid" : "AllowELBRootAccount",
        "Effect" : "Allow",
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.elb_log_bucket.arn}/*",
        "Principal" : {
          "AWS" : "${data.aws_elb_service_account.elb_sa.arn}"
        }
      },
      {
        "Sid" : "AWSLogDeliveryWrite",
        "Effect" : "Allow",
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.elb_log_bucket.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        },
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        }
      },
      {
        "Sid" : "AWSLogDeliveryAclCheck",
        "Effect" : "Allow",
        "Action" : "s3:GetBucketAcl",
        "Resource" : "${aws_s3_bucket.elb_log_bucket.arn}",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        }
      },
      {
        "Sid" : "AllowALBAccess",
        "Effect" : "Allow",
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.elb_log_bucket.arn}/*",
        "Principal" : {
          "Service" : "elasticloadbalancing.amazonaws.com"
        }
      }
    ]
  })
  depends_on = [aws_s3_bucket.elb_log_bucket]
}
