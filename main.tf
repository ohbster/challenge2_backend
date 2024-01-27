terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "ohbster-ado-terraform-class5"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}


#This is used by mff_id tag. This is will identify all resources that belong to the terraform deployment
resource "random_uuid" "uuid" {

}

#This will add the mff_id uuid to the common tags that get passed to resources. This will identify resources that belong to this deployment
locals {
  common_tags = merge(var.common_tags, { mff_id = random_uuid.uuid.result })
}

resource "aws_s3_bucket" "bucket" {
  force_destroy = true
  bucket = var.bucket_name
  tags = var.common_tags
}

resource "aws_s3_bucket_public_access_block" "s3_public_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on = [ aws_s3_bucket.bucket ]
}


resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }

  depends_on = [ aws_s3_bucket.bucket ]
}

resource "aws_s3_bucket_policy" "policy" {
  
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.bucket.arn}/*"
        }
    ]
})
depends_on = [ aws_s3_bucket.bucket ]
}
