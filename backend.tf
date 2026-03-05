terraform {
  backend "s3" {
    bucket         = "ondc-tfstate-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "ondc-tf"
    encrypt        = true
  }
}