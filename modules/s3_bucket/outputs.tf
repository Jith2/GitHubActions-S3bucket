output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "iam_policy_arn" {
  value = aws_iam_policy.limited_access.arn
}