resource "aws_s3_bucket" "provisioner_terraform_state" {
  bucket = "srvn-challenge-terraform-bucket"
  acl = "private"
 
    tags = {
    Name        = "srvn-challenge-tfstate-s3-bucket"
    Environment = "prod"
  }

  versioning {
    enabled = true
  }

}

resource "aws_s3_bucket_public_access_block" "svn-bucket-access-control" {
  bucket = aws_s3_bucket.provisioner_terraform_state.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

provider "aws" {
  region = var.aws_region
}


variable "aws_region" {
  description = "AWS region to setup the bucket"
  default = "us-east-1"
  
}