variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "subfolders" {
  description = "List of subfolders to create in the bucket"
  type        = list(string)
  default     = ["customers/import/", "customers/export/"]
}
variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}
