variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
variable "tags" {
  description = "Tags to apply to all buckets"
  type        = map(string)
  default     = {
    Application = "Campaign"
    OE          = "oneMarketing"
    Team        = "MarketingExecution"
    Use         = "DataImportExport"
  }
}