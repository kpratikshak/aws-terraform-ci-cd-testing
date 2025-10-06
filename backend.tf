 Remote State Backend (`backend.tf`)

This file configures Terraform to store its state file remotely in an S3 bucket and use a DynamoDB table for state locking, which is crucial for preventing concurrent modifications.

```terraform
# backend.tf - Configures remote state and locking

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-unique-name" # <-- CHANGE THIS
    key            = "cicd-pipeline/terraform.tfstate"
    region         = "ap-south-1" # Pune's region
    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true
  }
}

# Resource for the S3 bucket to store Terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = "my-terraform-state-bucket-unique-name" # <-- Use the same unique name as above

  lifecycle {
    prevent_destroy = true
  }
}

# Resource for the DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-state-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```
