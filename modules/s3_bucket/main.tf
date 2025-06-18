resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_object" "folders" {
  for_each = toset(var.subfolders)
  bucket   = aws_s3_bucket.this.id
  key      = each.value
  content  = ""
}

data "aws_iam_policy_document" "limited_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}
resource "aws_iam_policy" "limited_access" {
  name   = "${var.bucket_name}-policy"
  policy = data.aws_iam_policy_document.limited_access.json
}
resource "aws_s3_bucket_lifecycle_configuration" "expire_objects" {
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.subfolders
    content {
      id     = "expire-objects-30-days-${replace(rule.value, "/", "-")}"
      status = "Enabled"

      filter {
        prefix = rule.value
      }

      expiration {
        days = 30
      }
    }
  }
}
