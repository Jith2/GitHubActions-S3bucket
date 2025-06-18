# S3 Bucket Terraform Automation

## Overview

This Terraform project automates the creation and management of S3 buckets, IAM policies, and lifecycle rules.  
It is designed for environments where multiple S3 buckets are managed with consistent tagging, folder structure, and access controls, including cross-account scenarios.

---

## Structure

- **main.tf**: Root module, calls the S3 bucket module for each bucket defined in `customers.tfvars`.
- **variables.tf**: Defines variables for AWS region, tags, and customer buckets.
- **customers.tfvars**: Specifies the buckets and subfolders to create.
- **modules/s3_bucket/**: Module that creates an S3 bucket, subfolders, IAM policy, and lifecycle rules.

---

## Features

- **Creates S3 buckets** with custom tags.
- **Creates subfolders** as empty objects in each bucket.
- **Creates an IAM policy** for limited S3 access (Put, Get, Delete, List).
- **Adds lifecycle rules** to delete objects older than 30 days in each subfolder.
- **(Optional)**: Supports cross-account access via IAM roles and bucket policies.

---

## Usage

1. **Configure your variables:**

   Edit `customers.tfvars`:
   ```hcl
   customer_buckets = {
     "om-campaign-qa-agcs" = ["DataExportFromCampaign/", "DataImportToCampaign/"]
   }
   ```

2. **Initialize Terraform:**
   ```sh
   terraform init
   ```

3. **Plan and apply:**
   ```sh
   terraform plan -var-file="customers.tfvars"
   terraform apply -var-file="customers.tfvars"
   ```

---

## Cross-Account Access

- To allow another AWS account to access your S3 bucket, you can:
  - **Create an IAM role** in your account with a trust policy for the external account, and attach the S3 access policy to it.
  - **Or, add a bucket policy** that allows a user or role from the external account.

**Example bucket policy for cross-account access:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<EXTERNAL_ACCOUNT_ID>:user/<UserName>"
      },
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::<bucket-name>",
        "arn:aws:s3:::<bucket-name>/*"
      ]
    }
  ]
}
```
Replace `<EXTERNAL_ACCOUNT_ID>`, `<UserName>`, and `<bucket-name>` as needed.

---

## Notes

- The IAM policy is created but not attached to any user or role by default.
- The lifecycle rule is dynamic: any new folder added in `customers.tfvars` will automatically get a 30-day expiration rule.
- For cross-account access, ensure the correct bucket policy or IAM role trust relationship is in place.

---

## Troubleshooting

- If you do not see resources in AWS, check for errors during `terraform apply`.
- Make sure you are using the correct AWS credentials and region.
- For cross-account access, double-check ARNs and trust policies.

---

## License

MIT License (add your own license as appropriate)