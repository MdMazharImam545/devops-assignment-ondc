variable "region" {
  description = "AWS Region to select"
  type = string
  default = "ap-south-1"
}

variable "state_bucket_name" {
  description = "S3 bucket for Terraform remote state"
  type = string
  default = "ondc-tfstate-bucket"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table for state locking"
  type = string
  default = "ondc-tf"
}